# SocialKing

## Inspiration 🌟

It is useless to solve the creator economy before there is a new business model. Every change in the business model will produce a huge number of unicorn companies. The technological innovation of web3 is secondary. The most important thing is the emergence of new business models. The explosion of memes in the past year gave us the biggest inspiration: good content is naturally good memes. So can we use the thinking of memes to operate content platforms? So we proposed a new business model called speculative economy and adopted a unique way to practice it.

## What it does 🌍

SocialKing is an emerging content investment platform which is a Browser Extension that aims to solve the pain points in the creator economy and bring a new experience to creators, distributors, and consumers. Through innovative business models and technical means, SocialKing is committed to reshaping the future of content creation and distribution.

1. **Buy/Sell Content Shares**: Users can buy/sell content shares in different content generation platforms such as Twitter and YouTube, and obtain NFT(ERC1155) of the corresponding content to encourage the creation of high-quality content.
2. **Authentication**: Chainlink Functions is used to bind content generation platform accounts such as Twitter usernames and EOA so that the author of the post can get benefits.

![Alt text](https://cdn-fusion.imgimg.cc/i/2024/3c373c0e831bfe2c.png)

## How we built it 🛠️

SocialKing was constructed in several segments:

1. **Smart Contract**: Deployed on Polygon amoy, written in Solidity, with Solmate for standard contracts(ERC1155).
2. **Chrome Extension**: Built using React, Viem, and TypeScript.
3. **Extension Sidebar**: Utilized The Graph to display creator content that has been uploaded to the chain.
4. **Chainlink Integration**: Integrated Chainlink contracts, including Functions and Data Feeds.

## Challenges we ran into 😵

1. **Chainlink**: The sendRequest function of Chainlink Functions takes a long time to complete due to various network issues when obtaining results from off-chain APIs.
2. **Wallet Integration**: Introducing wallet functions into a Browser Extension is difficult and time-consuming.
3. **Extension Development**: Chrome Extension development library is complex and may cause many compatibility issues.
4. **Graph Deployment**: Deploying The Graph on Polygon poses different challenges compared to Sepolia.

## Accomplishments that we're proud of 🏆

1. **Decentralized Content Trading**: Successfully implemented a decentralized content trading system that allows users to buy and sell Creator Content.
2. **Chainlink Integration**: Integrated Chainlink Functions to bind username and EOA, and Chainlink Data Feeds to convert MATIC to USD.
3. **Revenue Sharing Model**: Developed an innovative revenue sharing model that ensures fair compensation for creators, distributors, and early investors.
4. **Enhanced User Experience**: Built a user-friendly platform that aggregates and sorts content for easy browsing and interaction.

## What we learned 💡

1. Gained significant knowledge in developing with Chainlink, Browser Extensions, and The Graph.
2. Became familiar with the integration of Browser Extensions and smart contracts.

## What's next for SocialKing 🔮

1. **Platform Expansion**: Apply the application to other social media platforms, such as YouTube and GitHub, and explore potential integrations and collaborations.
2. **User Experience Improvement**: Continuously optimize and add new features to enhance user experience.
3. **Long-term Vision**: Guide users to make SocialKing the preferred platform for content publishing.

## Links

1. [SocialKing contract](https://amoy.polygonscan.com/address/0xD8266130898E157A27a227bc655CdF4BC0727fB1)
2. [SocialKingFunctionsConsumer contract](https://amoy.polygonscan.com/address/0xD8ff54a41D50b34F42a79615355d9FdC9F8E401C)
3. [ChainLink Functions Subscription](https://functions.chain.link/polygon-amoy/285)
4. [SocialKingDataConsumer contract](https://amoy.polygonscan.com/address/0xC4f13eE12061867E7c3a750AC7B1Fed33C04E619)
