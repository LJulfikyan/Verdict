# Security Hardening Report

## Files Modified
- `functions/index.js`

## Files Added
- `firestore.rules`
- `FIREBASE_SETUP.md`
- `SECURITY_HARDENING_REPORT.md`

## Rules Added
- Added committed Firestore rules in `firestore.rules`
- Preserved direct Firestore read architecture for:
  - `cases`
  - owner-scoped `notifications`
  - owner-scoped `saved_cases`
- Preserved startup-critical user document writes:
  - owner create/update/delete on `users/{userId}`
- Protected server-managed fields from direct client mutation:
  - `votesCount`
  - `reportsCount`
  - `savesCount`
  - `sharesCount`
  - `hotScore`
  - `winnerOption`
  - `premium`
  - `trustScore`
  - `role`
  - `isBanned`
- Denied direct client writes to:
  - `analytics_events`
  - `audit_logs`
  - `boosts`
  - `subscriptions`

## Callable Changes
- Hardened implemented callables:
  - `voteCase`
  - `createCase`
  - `saveCase`
  - `reportCase`
  - `markNotificationRead`
- Standardized shared participant validation:
  - auth required
  - user document must exist
  - banned users denied
  - guest users denied for protected mutations
- Standardized structured callable error details:
  - `success: false`
  - `error.code`
  - `error.message`

## Audit Logging Implementation
- Added lightweight audit log support in `functions/index.js`
- Audit records are written to:
  - `audit_logs/{logId}`
- Implemented logging for:
  - `reportCase`
  - milestone notification creation
- Audit log structure:
  - `action`
  - `userId`
  - `targetId`
  - `metadata`
  - `createdAt`

## Self-Vote Prevention Implementation
- Added explicit self-vote prevention in `voteCase`
- Enforced server-side in `functions/index.js`
- Behavior:
  - if `case.authorId == request.auth.uid`, voting is rejected
- Error returned:
  - `error.code = "self_vote_not_allowed"`
  - `error.message = "Authors cannot vote on their own cases."`
- Rationale documented inline in code:
  - reduce manipulation risk
  - preserve jury integrity

## Rate Limiting Implementation
- Added reusable rate limit helper in `functions/index.js`
- Added integration hooks for:
  - `createCase`
  - `voteCase`
  - `reportCase`
  - `saveCase`
- Current mode:
  - configured but disabled by default
  - development-friendly
- Rate limit activity is prepared against `audit_logs`

## Firebase Setup Documentation
- Added `FIREBASE_SETUP.md`
- Includes:
  - required Firebase services
  - deployment commands
  - required indexes
  - required environment variables
  - local setup steps
  - production deployment checklist

## Remaining Security Gaps
- Rate limiting is not actively enforced yet because the helper is disabled by default.
- Firestore rules are intentionally not aggressively tightened to avoid breaking current repositories.
- Some non-business direct writes still exist outside pure Cloud Function mutation flow:
  - user bootstrap/profile sync
  - token persistence
  - notification deletion
- No App Check enforcement was added in this pass.
- No IP/device-hash abuse detection was added in this pass.
- No moderator/admin action callables were implemented, so moderation audit coverage is limited to future integration points.
- Functions implementation remains single-file JavaScript, not the spec’d TypeScript modular structure.
