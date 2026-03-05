Notion Integration Guide (for OpenClaw Skill)

Goal
- Create a secure Notion integration and prepare the workspace so the OpenClaw skill can read/write items for the "예약 큐" and send alerts.

Step 1 — Create Notion Integration
1. Go to https://www.notion.so/my-integrations and click "+ New integration".
2. Give it a name like "OpenClaw Karaoke Skill" and (optionally) an icon.
3. Choose the workspace you want to connect.
4. Under Capabilities, enable the minimum scopes required: "Read content" and "Insert content" (or "Read, Update, Create, and Delete" for full control). Avoid full workspace access—pick specific databases if possible.
5. Create the integration and copy the "Internal Integration Token" (keep it secret).

Step 2 — Prepare Notion Database(s)
- Recommended DB: "Reservation Queue"
  - Properties:
    - Name (Title)
    - YouTube Link (URL)
    - Scheduled At (Date & time)
    - Status (Select: queued / playing / done / cancelled)
    - Notes (Text)
    - Created By (Text)

- Create the DB in Notion, then open its Share menu and invite the integration you created (search integration name). This grants the integration access to that DB.

Step 3 — Secure Token Handling (recommended)
Option A (No server - OpenClaw skill-only):
- Store the token in a protected file on the host running OpenClaw (not in chat). Example path: C:\Users\<you>\.openclaw\secrets\notion_token.txt
- Set file permissions so only your user account can read it. Provide the secure path to the skill configuration (not the token text in chat).

Option B (Recommended - server-assisted):
- Deploy a small backend (Node.js) and store the token in environment variable or Vault (Hashicorp Vault / cloud secret manager).
- The server performs polling and exposes a small webhook/endpoint the OpenClaw skill can call to retrieve events. The server notifies OpenClaw via sessions_send or message tool when events occur.

Step 4 — Test Token & DB Access (manual)
- Use curl or Postman to confirm token and DB access:
  - Example: GET database query
    curl "https://api.notion.com/v1/databases/<DATABASE_ID>/query" \
      -H "Authorization: Bearer <INTEGRATION_TOKEN>" \
      -H "Notion-Version: 2022-06-28"
- If you get results, the integration has correct access.

Step 5 — Provide Configuration to OpenClaw Skill
- Preferred: Provide OpenClaw with a secure path to the token (e.g., file path or server URL) and the target database ID(s). Do NOT paste the token in chat.
- Example config object (skill):
  {
    "notion_token_path": "C:\\Users\\you\\.openclaw\\secrets\\notion_token.txt",
    "database_ids": {
      "reservation_queue": "<DATABASE_ID>"
    },
    "poll_interval_seconds": 60
  }

Step 6 — Basic Commands to Try (after skill enabled)
- "노션 예약 추가: 제목=테스트곡; 링크=https://youtu.be/xxxx; 시간=오늘 21:00"
- "노션 예약 보기"
- "노션 예약 삭제 [id]"
- "노션 동기화 지금" (force polling)

Security Notes
- Rotate integration token if accidental exposure is suspected. Revoke the integration from Notion and recreate with a new token.
- Limit integration access to minimal DBs.
- Audit changes: keep logs in workspace/memory for every automated change.

If you want, I can generate the Node.js server skeleton that polls the DB and sends OpenClaw messages. Reply with 'generate server' and tell me whether you want polling interval default 60s or higher (e.g., 300s).