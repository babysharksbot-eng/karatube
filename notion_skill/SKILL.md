# Notion Sync Skill (OpenClaw)

Purpose
- Provide an OpenClaw skill for bidirectional synchronization between the session and a Notion workspace.
- Primary use case: manage "예약 큐" (reservation queue) and schedule-based alerts; allow creation/update/read/delete of Notion pages/DB entries from chat commands; send notifications to the user (Telegram) when Notion items meet conditions.

Capabilities
- Create / Read / Update / Delete Notion database items (pages) mapped to app concepts (예약 큐, Tasks, Notes).
- Schedule polling or cron-based checks for scheduled items and send alerts to the user via OpenClaw message tool.
- Provide natural-language command handlers: e.g. "노션에 예약 추가: 제목=노래1, 시간=오늘 21:00" → creates DB row.
- Support manual sync commands and conflict-resolution prompts.

Security & Permissions
- Notion Integration Token is required. The skill will not request or store tokens in chat.
- Recommended token handling: user stores the Notion integration token in a secure location (Vault / environment variable / server secret store) and provides the skill with a secure path or a short-lived credential. The skill should be configured to read tokens from a secure store at run time.
- Integration should be given least-privilege access to specific database(s) used for the app.

Design Decisions
- Polling vs Webhook: Notion does not provide general webhooks for all accounts. The skill uses polling (configurable interval) or an optional intermediate server that implements persistence and scheduling for higher reliability.
- Two deployment modes:
  1) "Skill-only" (no external server): OpenClaw runs polling cron jobs and calls Notion REST API directly. Simpler to deploy, but limited control over token storage and scaling.
  2) "Server-assisted" (recommended for production): lightweight server (Node.js) holds secure token, performs scheduled polling, and notifies OpenClaw via sessions_send/message or via the OpenClaw cron integration.

Commands / Intents (examples)
- "노션 예약 추가: 제목=...; 링크=...; 시간=..." → create reservation
- "노션 예약 보기" → list next 10 queued items
- "노션 예약 삭제 3" → delete item with index/id
- "노션 동기화" → force a sync now
- "노션에서 변경 알림 받기" → enable notifications for changes (starts polling/cron)

Operational Notes
- All automatic writes require user confirmation policy: large batch updates or destructive ops must present a summary and request explicit approval before applying.
- Audit logs: record all changes in workspace/memory logs with Source: notion_skill and timestamp.

Integration Points
- Uses Notion REST API (v1). Key endpoints: search, databases.query, pages.create, pages.update, blocks.children.append.
- Uses OpenClaw message tool for outbound notifications (telegram:5748588215).

Files / Artifacts
- SKILL.md (this file) — skill description
- notion_skill/handler_template.js — (optional) sample handler to call Notion API
- notion_skill/cron_config.json — default polling interval and filters

Next steps
- I can generate SKILL.md-based handler template and a sample Node.js server skeleton that safely reads tokens from environment variables or a Vault. Tell me if you want the lightweight server skeleton now.

Recorded: 샤크
