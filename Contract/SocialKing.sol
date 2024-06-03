// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ERC1155} from "solmate/src/tokens/ERC1155.sol";

error Unauthorized();

contract SocialKing is ERC1155 {
    event Create(uint256 indexed assetId, address indexed sender, string arTxId);
    event Remove(uint256 indexed assetId, address indexed sender);
    event Trade(
        TradeType indexed tradeType,
        uint256 indexed assetId,
        address indexed sender,
        uint256 tokenAmount,
        uint256 ethAmount,
        uint256 creatorFee
    );
    event withdrawl(address indexed sender, uint256 ethAmount);

    struct Author {
        uint256 userId;
        uint256 platformId;
    }

    struct Asset {
        uint256 id;
        string arTxId; 
        address creator;
        string author;
    }

    address constant team = 0x23AE1FC8E4e40274BeB45bb63f773C902EDD7423;
    uint256 public assetIndex = 1;
    mapping(uint256 => Asset) public assets;
    mapping(address  => string) public authors;
    mapping(address => uint256[]) public userAssets;
    mapping(bytes32 => uint256) public txToAssetId;
    mapping(uint256 => uint256) public totalSupply;
    mapping(uint256 => uint256) public pool;
    mapping(address => uint256) public userBalance;
    mapping(string => uint256) public authorBalance;


    uint256 public constant CREATOR_PREMINT = 1 ether; // 1e18
    uint256 public constant CREATOR_FEE_PERCENT = 0.01 ether; // 1%
    uint256 public constant AUTHOR_FEE_PERCENT = 0.03 ether; // 3%
    uint256 public constant TEAM_FEE_PERCENT = 0.01 ether; // 1%
    enum TradeType {
        Mint,
        Buy,
        Sell
    } // = 0, 1, 2

    function create(string calldata arTxId, string memory author) public {
        bytes32 txHash = keccak256(abi.encodePacked(arTxId));
        require(txToAssetId[txHash] == 0, "Asset already exists");
        uint256 newAssetId = assetIndex;
        assets[newAssetId] = Asset(newAssetId, arTxId, msg.sender, author);
        userAssets[msg.sender].push(newAssetId);
        txToAssetId[txHash] = newAssetId;
        totalSupply[newAssetId] += CREATOR_PREMINT;
        assetIndex = newAssetId + 1;
        _mint(msg.sender, newAssetId, CREATOR_PREMINT, "");
        emit Create(newAssetId, msg.sender, arTxId);
        emit Trade(TradeType.Mint, newAssetId, msg.sender, CREATOR_PREMINT, 0, 0);
    }

    function remove(uint256 assetId) public {
        Asset memory asset = assets[assetId];
        if (asset.creator != msg.sender) {
            revert Unauthorized();
        }
        delete txToAssetId[keccak256(abi.encodePacked(asset.arTxId))];
        delete assets[assetId];
        emit Remove(assetId, msg.sender);
    }

    function getAssetIdsByAddress(address addr) public view returns (uint256[] memory) {
        return userAssets[addr];
    }

    function _curve(uint256 x) private pure returns (uint256) {
        return x <= CREATOR_PREMINT ? 0 : ((x - CREATOR_PREMINT) * (x - CREATOR_PREMINT) * (x - CREATOR_PREMINT));
    }

    function getPrice(uint256 supply, uint256 amount) public pure returns (uint256) {
        return (_curve(supply + amount) - _curve(supply)) / 1 ether / 1 ether / 50_000;
    }

    function getBuyPrice(uint256 assetId, uint256 amount) public view returns (uint256) {
        return getPrice(totalSupply[assetId], amount);
    }

    function getSellPrice(uint256 assetId, uint256 amount) public view returns (uint256) {
        return getPrice(totalSupply[assetId] - amount, amount);
    }

    function getBuyPriceAfterFee(uint256 assetId, uint256 amount) public view returns (uint256) {
        uint256 price = getBuyPrice(assetId, amount);
        uint256 creatorFee = (price * CREATOR_FEE_PERCENT) / 1 ether;
        uint256 authorFee = (price * AUTHOR_FEE_PERCENT) / 1 ether;
        uint256 teamFee = (price * TEAM_FEE_PERCENT) / 1 ether;

        return price + creatorFee + authorFee + teamFee;
    }

    function getSellPriceAfterFee(uint256 assetId, uint256 amount) public view returns (uint256) {
        uint256 price = getSellPrice(assetId, amount);
        uint256 creatorFee = (price * CREATOR_FEE_PERCENT) / 1 ether;
        uint256 authorFee = (price * AUTHOR_FEE_PERCENT) / 1 ether;
        uint256 teamFee = (price * TEAM_FEE_PERCENT) / 1 ether;
        return price - creatorFee - authorFee - teamFee;
    }

    function buy(uint256 assetId, uint256 amount) public payable {
        require(assetId < assetIndex, "Asset does not exist");
        uint256 price = getBuyPrice(assetId, amount);
        uint256 creatorFee = (price * CREATOR_FEE_PERCENT) / 1 ether;
        uint256 authorFee = (price * AUTHOR_FEE_PERCENT) / 1 ether;
        uint256 teamFee = (price * TEAM_FEE_PERCENT) / 1 ether;
        require(msg.value >= price + creatorFee + authorFee + teamFee, "Insufficient payment");
        totalSupply[assetId] += amount;
        pool[assetId] += price;
        _mint(msg.sender, assetId, amount, "");
        userBalance[assets[assetId].creator] += creatorFee;
        authorBalance[assets[assetId].author] += authorFee;
        userBalance[team] += teamFee;
    }

    function sell(uint256 assetId, uint256 amount) public {
        require(assetId < assetIndex, "Asset does not exist");
        require(balanceOf[msg.sender][assetId] >= amount, "Insufficient balance");
        uint256 supply = totalSupply[assetId];
        require(supply - amount >= CREATOR_PREMINT, "Supply not allowed below premint amount");
        uint256 price = getSellPrice(assetId, amount);
        uint256 creatorFee = (price * CREATOR_FEE_PERCENT) / 1 ether;
        uint256 authorFee = (price * AUTHOR_FEE_PERCENT) / 1 ether;
        uint256 teamFee = (price * TEAM_FEE_PERCENT) / 1 ether;
        _burn(msg.sender, assetId, amount);
        totalSupply[assetId] = supply - amount;
        pool[assetId] -= price;
        userBalance[assets[assetId].creator] += creatorFee;
        authorBalance[assets[assetId].author] += authorFee;
        userBalance[team] += teamFee;
        userBalance[msg.sender] += price - creatorFee - authorFee - teamFee;    
    }

    function uri(uint256 id) public view override returns (string memory) {
        return assets[id].arTxId;
    }

    function updateReturnData(string memory _username, address _useraddress) external {
        authors[_useraddress] = _username;        
    }

    // Withdraw for user and team
    function claim() external {
        uint256 balance = userBalance[msg.sender];
        require(balance > 0, "No balance to claim");
        userBalance[msg.sender] = 0;
        emit withdrawl(msg.sender, balance);
        (bool success,) = payable(msg.sender).call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    // Withdraw for author
    function authorClaim() external {
        uint256 balance = authorBalance[authors[msg.sender]];
        require(balance > 0, "No balance to claim");
        authorBalance[authors[msg.sender]] = 0;
        emit withdrawl(msg.sender, balance);
        (bool success,) = payable(msg.sender).call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    function getUserBalance() external view returns (uint256) {
        return userBalance[msg.sender];
    }

    function getAuthorBalance() external view returns (uint256) {
        return authorBalance[authors[msg.sender]];
    }
}