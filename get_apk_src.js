const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    await page.goto('https://www.biligame.com/detail/?id=101772', { waitUntil: 'networkidle2' });
    const content = await page.content();
    console.log(content);
    await browser.close();
})();