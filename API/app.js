// app.js
const express = require('express');
const axios = require('axios');
require('dotenv').config();

const app = express();
const port = 3000;

app.use(express.json());

app.post('/verify', async (req, res) => {
  const { twitterUsername, ethereumAddress } = req.body;

  if (!twitterUsername || !ethereumAddress) {
    return res.status(400).json({ error: 'Twitter username or Ethereum address is empty' });
  }

  const requiredStringIncluded = `Verifying my Twitter account for ${ethereumAddress} using SocialKing`;
  const MAX_RESULTS = 10;
  let result = -1;

//   try {
    // const twitterRequest = {
    //   userIdByUsername: async () => {
    //     return await axios.get(`https://api.twitter.com/2/users/by/username/${twitterUsername}`, {
    //       headers: { Authorization: `Bearer ${process.env.TWITTER_BEARER_TOKEN}` },
    //     });
    //   },
    //   lastTweetsByUserId: async (userId) => {
    //     return await axios.get(`https://api.twitter.com/2/users/${userId}/tweets?max_results=${MAX_RESULTS}`, {
    //       headers: { Authorization: `Bearer ${process.env.TWITTER_BEARER_TOKEN}` },
    //     });
    //   },
    // };

    // const idRes = await twitterRequest.userIdByUsername();

    // if (!idRes.data || !idRes.data.data || !idRes.data.data.id) {
    //   throw new Error('Twitter API request failed - could not get user id');
    // }

    // const userId = idRes.data.data.id;

    // const tweetsRes = await twitterRequest.lastTweetsByUserId(userId);

    // if (!tweetsRes.data || !tweetsRes.data.data) {
    //   throw new Error('Twitter API request failed - could not get tweets');
    // }

    // const tweets = tweetsRes.data.data;
    // const tweetTexts = tweets.map((tweet) => tweet.text);
    // const res = tweetTexts.some((text) =>
    //   text.toLowerCase().includes(requiredStringIncluded.toLowerCase()),
    // );
    result = 1;

    return res.json({ result, twitterUsername, ethereumAddress });
//   } catch (error) {
//     console.error(error);
//     return res.status(500).json({ error: 'Internal Server Error' });
//   }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
