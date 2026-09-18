// Headless smoke tests for the HTML pages in this repo.
// Loads each page in Chromium, fails on console errors, asserts interaction works.
// Run: node tests/smoke.mjs
import { chromium } from `playwright`;
import { fileURLToPath } from `url`;
import { dirname, join } from `path`;

const root = join(dirname(fileURLToPath(import.meta.url)), `..`);
const results = [];

function check(name, condition, detail) {
  results.push({ name, ok: Boolean(condition), detail });
}

async function open(browser, file) {
  const page = await browser.newPage();
  const errors = [];
  page.on(`console`, (m) => { if (m.type() === `error`) errors.push(m.text()); });
  page.on(`pageerror`, (e) => errors.push(e.message));
  await page.goto(`file://` + join(root, file), { waitUntil: `load` });
  return { page, errors };
}

const browser = await chromium.launch();

// Test 1 - Catch the Dot
{
  const { page, errors } = await open(browser, `smoke-test-1-catch-the-dot.html`);
  check(`catch-the-dot: title`, (await page.title()) === `Catch the Dot`);
  check(`catch-the-dot: arena exists`, (await page.locator(`#a`).count()) === 1);
  const before = Number(await page.locator(`#s`).textContent());
  await page.locator(`#d`).click();
  const after = Number(await page.locator(`#s`).textContent());
  check(`catch-the-dot: score increments`, after === before + 1, before + `->` + after);
  check(`catch-the-dot: no console errors`, errors.length === 0, errors.join(`|`));
  await page.close();
}

// Test 2 - Tic Tac Toe
{
  const { page, errors } = await open(browser, `smoke-test-2-tic-tac-toe.html`);
  check(`tic-tac-toe: title`, (await page.title()) === `Tic Tac Toe`);
  check(`tic-tac-toe: nine cells`, (await page.locator(`.c`).count()) === 9);
  const cells = page.locator(`.c`);
  await cells.nth(0).click();
  check(`tic-tac-toe: first move X`, (await cells.nth(0).textContent()) === `X`);
  await cells.nth(3).click();
  check(`tic-tac-toe: second move O`, (await cells.nth(3).textContent()) === `O`);
  check(`tic-tac-toe: no console errors`, errors.length === 0, errors.join(`|`));
  await page.close();
}

await browser.close();

let failed = 0;
for (const r of results) {
  if (!r.ok) failed += 1;
  console.log((r.ok ? `PASS ` : `FAIL `) + r.name + (r.detail ? `  [` + r.detail + `]` : `));
}
console.log(`);
console.log((results.length - failed) + `/` + results.length + ` checks passed`);
if (failed > 0) process.exit(1);
