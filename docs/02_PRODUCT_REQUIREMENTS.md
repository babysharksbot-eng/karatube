# Product Requirements (제품 요구사항서)

## 목적
사용자가 손쉽게 미디어(노래)를 검색하고, 큐에 추가하며, 재생 세션을 공유하는 것을 목표로 한다.

## 핵심 사용자 페르소나
- 동참자 A: 파티 호스트 — 큐를 관리하고 미디어를 재생한다.
- 동참자 B: 참여자 — 큐에 곡을 추가하거나 추천한다.
- 관중: 재생만 소비하는 사용자

## MVP 기능 (우선순위)
1. 검색(검색어 → 외부 API/YouTube 검색 결과 표시) — 필수
2. 큐(Reservation Queue) 추가/삭제/순서 변경 — 필수
3. 플레이어(재생, 일시정지, 다음) — 필수
4. 로컬/간단 동기화(폴링 기반) — 필수
5. 사용자 프로필(닉네임) — 선택
6. AirPlay 출력 지원(iOS) — 선택

## 사용자 흐름(간단)
1. 앱 실행 → 홈(추천/최근) 또는 검색 진입
2. 검색 결과에서 ‘큐에 추가’ 선택 → 큐에 아이템 추가
3. 플레이어에서 ‘재생’ → 재생 및 제어
4. (호스트) 큐 관리 → 순서 변경/삭제

## 비기능 요구사항
- 동기화 지연 상한: 5초(폴링 기본값) — 기본 동기화 주기 60초 권장, 이벤트 발생 시 즉시 푸시(옵션)
- 오프라인 동작: 로컬 큐 보존, 네트워크 복구 후 자동 동기화
- 보안: 토큰은 환경 변수/Vault 사용, 절대 공개채팅에 노출 금지

## 데이터 모델(간략)
- Item: id, title, sourceUrl, thumbnail, duration, addedBy, addedAt
- Queue: id(sessionId), items[], host, mode(public/private), updatedAt
- User: id, displayName, role(host/participant)

## API 요구(요약)
- GET /search?q=... → 검색 결과
- POST /queues → 큐 생성
- POST /queues/{id}/items → 아이템 추가
- PATCH /queues/{id}/items/{itemId} → 순서/상태 변경
- GET /queues/{id} → 큐 상태 조회

## 승인 기준
- QA: 주요 플로우(검색→큐→재생) 시나리오 테스트 통과
- 보안리뷰: 인증 토큰 관리 방식 검토 및 문서화

---

다음 단계: Architecture 문서에서 시스템 컴포넌트와 데이터 흐름을 상세화합니다.