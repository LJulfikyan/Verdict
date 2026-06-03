# api.md
## Verdict – Relationship Jury
### Backend API & Cloud Functions Specification v1.0

# Architecture

Backend:
Firebase Functions

API Style:
Callable Functions

Authentication:
Firebase Auth JWT

# Function: createCase

Input:

{
  "relationshipType": "wife",
  "category": "money",
  "description": "text",
  "question": "Was I wrong?"
}

Validation:

- relationshipType required
- category required
- description 50-500 chars
- question 1-100 chars

Response:

{
  "success": true,
  "caseId": "abc123"
}

Errors:

invalid_relationship_type
invalid_category
description_too_short
description_too_long
unauthorized

# Function: voteCase

Input:

{
  "caseId": "abc123",
  "option": "youRight"
}

Rules:

- user authenticated
- user has not voted before
- case exists
- case active

Transaction:

1. create vote document
2. increment selected option
3. increment votesCount
4. recalculate winnerOption

Response:

{
  "success": true,
  "results": {
    "youRight": 72,
    "theyRight": 15,
    "bothWrong": 8,
    "needInfo": 5
  }
}

# Function: saveCase

Input:

{
  "caseId": "abc123"
}

Response:

{
  "success": true
}

Behavior:

Toggle save state.

# Function: reportCase

Input:

{
  "caseId": "abc123",
  "reason": "spam"
}

Valid Reasons:

spam
fake_story
personal_information
harassment
other

Behavior:

Create report document.

Increment reportsCount.

If threshold exceeded:

status = hidden

Response:

{
  "success": true
}

# Function: boostCase

Input:

{
  "caseId": "abc123"
}

Validation:

- payment completed
- user owns case

Behavior:

Create boost record.

Apply multiplier.

Response:

{
  "success": true,
  "expiresAt": "timestamp"
}

# Function: markNotificationRead

Input:

{
  "notificationId": ""
}

Response:

{
  "success": true
}

# Function: deleteAccount

Input:

{}

Behavior:

- remove user data
- anonymize authored cases
- remove saved cases
- remove notifications

Response:

{
  "success": true
}

# Function: updateProfile

Input:

{
  "displayName": "John"
}

Validation:

1-30 chars

Response:

{
  "success": true
}

# Function: getPremiumStatus

Response:

{
  "isPremium": true,
  "plan": "monthly",
  "expiresAt": ""
}

# RevenueCat Webhook

Events:

INITIAL_PURCHASE

RENEWAL

EXPIRATION

CANCELLATION

Behavior:

Update subscription status.

# Ad Tracking Endpoint

Event:

ad_impression

Payload:

{
  "placement": "feed_native"
}

# Analytics Events

case_view

case_vote

case_create

case_share

case_save

premium_open

premium_purchase

boost_purchase

notification_open

# Scheduled Function

recalculateHotScores

Frequency:

10 minutes

Logic:

hotScore =
(votesCount * 4)
+ (sharesCount * 6)
+ (savesCount * 2)

Apply boost multiplier.

# Scheduled Function

expireBoosts

Frequency:

1 hour

Behavior:

Deactivate expired boosts.

# Scheduled Function

cleanupAnalytics

Frequency:

24 hours

# Notification Triggers

Case reaches:

100 votes

500 votes

1000 votes

5000 votes

Trigger notification.

# Trending Trigger

If hotScore exceeds threshold.

Create notification.

# Firestore Triggers

onCaseCreated

onVoteCreated

onReportCreated

onSubscriptionUpdated

# Error Format

{
  "success": false,
  "error": {
    "code": "description_too_short",
    "message": "Description must contain at least 50 characters."
  }
}

# Rate Limits

Create Case:

5 per day

Vote:

500 per day

Report:

50 per day

Save:

Unlimited

# Future APIs

comments

appeals

admin dashboard

A/B testing

theme marketplace

Not required for MVP.
