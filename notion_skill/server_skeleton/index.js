require('dotenv').config();
const fetch = require('node-fetch');

const NOTION_TOKEN = process.env.NOTION_TOKEN;
const DATABASE_ID = process.env.DATABASE_ID;
const POLL_INTERVAL = parseInt(process.env.POLL_INTERVAL_SECONDS || '60', 10);
const NOTION_VERSION = '2022-06-28';

if (!NOTION_TOKEN || !DATABASE_ID) {
  console.error('Please set NOTION_TOKEN and DATABASE_ID in .env');
  process.exit(1);
}

async function queryDatabase() {
  const url = `https://api.notion.com/v1/databases/${DATABASE_ID}/query`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${NOTION_TOKEN}`,
      'Notion-Version': NOTION_VERSION,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ page_size: 10 })
  });
  if (!res.ok) {
    console.error('Notion query failed', res.status, await res.text());
    return null;
  }
  return res.json();
}

let lastSeen = {};

async function pollOnce() {
  try {
    const data = await queryDatabase();
    if (!data) return;
    const results = data.results || [];
    // Simple change detection: compare lastSeen ids
    for (const page of results) {
      const id = page.id;
      if (!lastSeen[id]) {
        // new item discovered
        console.log('New item', id, page);
        // TODO: call OpenClaw message endpoint or sessions_send
      }
      lastSeen[id] = Date.now();
    }
    // cleanup old
    for (const k of Object.keys(lastSeen)) {
      if (!results.find(r => r.id === k)) delete lastSeen[k];
    }
  } catch (e) {
    console.error('Poll error', e);
  }
}

console.log('Starting Notion poller, interval', POLL_INTERVAL, 's');
setInterval(pollOnce, POLL_INTERVAL * 1000);
// first run
pollOnce();
