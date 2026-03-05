// OpenClaw Notion Skill Handler Template
// Usage: integrate this into the skill runtime. This is a minimal handler that
// reads configuration (token path, database IDs) and exposes basic CRUD functions
// for Notion. It does NOT include token retrieval code; you must supply a secure
// method to provide the token (environment variable, protected file, or server).

const fetch = require('node-fetch');

class NotionClient {
  constructor({ getToken, notionVersion = '2022-06-28' }) {
    this.getToken = getToken; // async function returning Bearer token
    this.notionVersion = notionVersion;
    this.base = 'https://api.notion.com/v1';
  }

  async request(path, method = 'GET', body = null) {
    const token = await this.getToken();
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Notion-Version': this.notionVersion,
      'Content-Type': 'application/json'
    };
    const res = await fetch(this.base + path, {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined
    });
    if (!res.ok) {
      const text = await res.text();
      throw new Error(`Notion API error ${res.status}: ${text}`);
    }
    return res.json();
  }

  // Query a database
  async queryDatabase(databaseId, filter = null, sorts = null, pageSize = 20) {
    const body = { page_size: pageSize };
    if (filter) body.filter = filter;
    if (sorts) body.sorts = sorts;
    return this.request(`/databases/${databaseId}/query`, 'POST', body);
  }

  // Create a page in a database
  async createPage(databaseId, properties = {}, children = []) {
    const body = {
      parent: { database_id: databaseId },
      properties,
    };
    if (children && children.length) body.children = children;
    return this.request('/pages', 'POST', body);
  }

  // Update a page
  async updatePage(pageId, properties = {}) {
    return this.request(`/pages/${pageId}`, 'PATCH', { properties });
  }

  // Simple search
  async search(query, options = {}) {
    const body = { query, ...options };
    return this.request('/search', 'POST', body);
  }
}

module.exports = NotionClient;
