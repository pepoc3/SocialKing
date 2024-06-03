// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts@1.1.1/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract SocialKingDataConsumer {
    AggregatorV3Interface internal dataFeed;

    /**
     * Network: Polygon Amoy
     * Aggregator: MATIC / USD
     * Address: 0x001382149eBa3441043c1c66972b4772963f5D43
     */
    constructor() {
        dataFeed = AggregatorV3Interface(
            0x001382149eBa3441043c1c66972b4772963f5D43
        );
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
}
