# Architecture Overview (상위 구조 설계)

## 목표
시스템을 간단한 컴포넌트로 분해하여 책임과 인터페이스를 명확히 한다. 초기 MVP는 낮은 복잡도와 간단한 운영(폴링 기반 동기화)을 우선한다.

## 컴포넌트 다이어그램 (텍스트)

Client (iOS 앱)
- UI (검색, 큐, 플레이어)
- Local Queue Manager (로컬 상태 유지, 오프라인 지원)
- Sync Agent (폴링으로 서버와 큐 상태 동기화)
- Player (AVPlayer wrapper, AirPlay 지원)

Backend (간단 Node.js 서버)
- API Layer: 검색 프록시, 큐 관리 엔드포인트
- Data Store: 경량 DB (예: SQLite/Redis or hosted DB)
- Notion Integration (옵션): 작업/문서 동기화용

Optional Services
- Third-party Search API: YouTube Data API or alternative
- Notification/Realtime: Webhook 또는 WebSocket(확장 시)

## 데이터 흐름(간단)
1. 사용자 검색 → Client hits /search → Backend proxies to YouTube → returns results
2. 사용자가 큐에 추가 → Client POST /queues/{id}/items → Backend persists and returns updated queue
3. 다른 참가자 폴링 GET /queues/{id} 주기적으로 또는 On-demand로 상태 갱신
4. 플레이어는 큐의 현재 아이템을 재생

## 배포 아키텍처(초안)
- Client: App Store / TestFlight (iOS)
- Backend: 작은 Node.js 앱 (Heroku / Railway / Vercel serverless functions) + managed DB (Postgres/Filestore)
- Optional: Redis for ephemeral queue state (if necessary)

## 확장 포인트
- WebSocket을 통한 실시간 동기화 (세션 내 지연 최소화)
- 권한/역할(호스트/참가자) 관리 강화
- 멀티플레이어 동작 동기화(정밀 타이밍 요구시 별도 오토메이션)

## 운영·모니터링(간단)
- Error/Crash: Sentry (Client), Server logs centralized(Cloud provider logs)
- Metrics: request latency, queue lengths, playback errors

---

다음 문서로는 Security & Privacy, Notion integration 스키마, Figma 와이어프레임 준비를 이어서 하겠습니다.