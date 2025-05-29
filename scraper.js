const puppeteer = require("puppeteer");

async function scrapeTweet(tweetUrl) {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'] // required for sandboxed platforms like Render
  });

  try {
    const page = await browser.newPage();
    await page.goto(tweetUrl, { waitUntil: 'networkidle2', timeout: 0 });

    await page.waitForSelector('article [data-testid="tweetText"]');

    const tweetText = await page.$eval(
      'article [data-testid="tweetText"]',
      el => el.innerText
    );

    const mediaUrls = await page.$$eval('article img[src]', imgs =>
      imgs
        .map(img => img.src)
        .filter(src => src.includes('twimg.com/media'))
    );

    const stats = await page.$$eval('article [data-testid]', els => {
      const data = {};
      els.forEach(el => {
        const label = el.getAttribute('data-testid');
        const text = el.innerText;
        if (label && text) {
          data[label] = text;
        }
      });
      return data;
    });

    const username = tweetUrl.split('/')[3];
    const tweetId = tweetUrl.split('/status/')[1]?.split('?')[0];

    return {
      tweet_id: tweetId,
      username,
      text: tweetText,
      media: mediaUrls,
      stats,
      scraped_from: tweetUrl,
    };
  } catch (err) {
    console.error('[Scraper Error]', err);
    throw err;
  } finally {
    await browser.close();
  }
}

module.exports = scrapeTweet;