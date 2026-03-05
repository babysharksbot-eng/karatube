# Notion Project Schema (초안)

이 문서는 Notion을 프로젝트 협업/문서 중앙화로 사용할 때 권장되는 데이터베이스 구조를 설명합니다. Notion integration을 통해 OpenClaw/서버가 DB를 읽고 변경사항을 감지할 수 있습니다.

1) Database: Projects
- Properties:
  - Name (Title)
  - Status (Select: Planning / In Progress / Review / Done)
  - Owner (Person or Text)
  - Start Date (Date)
  - Due Date (Date)
  - Git Repo (URL)

2) Database: Tasks
- Properties:
  - Title (Title)
  - Project (Relation -> Projects)
  - Status (Select: Todo / Doing / Done / Blocked)
  - Priority (Select: High / Medium / Low)
  - Assignee (Person or Text)
  - Due (Date)
  - Notes (Text)

3) Database: Specs (문서 요약 저장소)
- Properties:
  - Title
  - Related Project
  - Doc Type (Select: PRD / Architecture / API / UX)
  - Link (URL to Git or Notion page)
  - Last Updated (Date)

4) Integration Notes
- Notion integration token (NOTION_TOKEN)은 안전하게 서버 환경변수로 보관.
- Polling interval default: 60s (configurable)
- Change detection: last_edited_time 비교, 또는 간단한 hash 비교

5) Usage
- 개발 중 핵심 문서(PRD/Arch/API)를 Notion에 복사해두고, 작업 항목을 Tasks DB로 관리하세요.
- Notion DB의 변경을 서버가 감지하면 OpenClaw 메시지 툴로 알림을 보낼 수 있습니다.

---

다음 단계: notion_skill/server_skeleton 에 폴링 핸들러 예시(환경변수 사용)를 추가합니다.