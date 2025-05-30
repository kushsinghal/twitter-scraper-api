require('dotenv').config();
const express = require('express');
const scrapeTweet = require('./scraper');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(require('cors')());

app.get('/scrape', async (req, res) => {
  const { tweetUrl } = req.query;

  if (!tweetUrl || (!tweetUrl.includes('twitter.com') && !tweetUrl.includes('x.com'))) {
    return res.status(400).json({ error: 'Invalid or missing Twitter/X URL' });
  }

  try {
    const data = await scrapeTweet(tweetUrl);
    res.json(data);
  } catch (err) {
    console.error('Scraping failed:', err);
    res.status(500).json({ error: 'Failed to scrape tweet' });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});
