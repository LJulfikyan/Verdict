# database.md
## Verdict – Relationship Jury
### Database & Firestore Specification v1.0

# Database Choice

Primary Database:
Firestore

Reason:
- Real-time
- Scalable
- Offline support
- Flutter friendly

# Collections

users
cases
votes
reports
notifications
saved_cases
premium_subscriptions
boosts
analytics_events

# users

Collection:
users/{userId}

Document:

{
  "id": "uid",
  "displayName": "John",
  "photoUrl": "",
  "provider": "google",
  "premium": false,
  "createdAt": "timestamp",
  "lastSeenAt": "timestamp",
  "casesCount": 0,
  "votesCount": 0,
  "savedCount": 0,
  "reportsCount": 0,
  "agreementScore": 0,
  "country": "",
  "gender": "",
  "ageRange": "",
  "isBanned": false
}

# cases

Collection:
cases/{caseId}

Document:

{
  "id": "",
  "authorId": "",
  "relationshipType": "wife",
  "category": "money",
  "description": "",
  "question": "",
  "status": "active",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "votesCount": 0,
  "viewsCount": 0,
  "savesCount": 0,
  "reportsCount": 0,
  "sharesCount": 0,
  "hotScore": 0,
  "winnerOption": "",
  "resultVisible": true
}

# Vote Aggregation

Stored inside case document.

{
  "youRight": 0,
  "theyRight": 0,
  "bothWrong": 0,
  "needInfo": 0
}

# votes

Collection:

cases/{caseId}/votes/{userId}

Document:

{
  "userId": "",
  "caseId": "",
  "option": "youRight",
  "createdAt": "timestamp"
}

Rules:

One vote per user.

User cannot update vote.

# reports

Collection:

cases/{caseId}/reports/{reportId}

{
  "userId": "",
  "reason": "spam",
  "createdAt": "timestamp"
}

# notifications

users/{userId}/notifications/{notificationId}

{
  "title": "",
  "body": "",
  "type": "case_trending",
  "isRead": false,
  "createdAt": "timestamp",
  "targetId": ""
}

# saved_cases

users/{userId}/saved_cases/{caseId}

{
  "caseId": "",
  "savedAt": "timestamp"
}

# premium_subscriptions

users/{userId}/subscriptions/{subscriptionId}

{
  "provider": "revenuecat",
  "plan": "monthly",
  "isActive": true,
  "startedAt": "",
  "expiresAt": ""
}

# boosts

boosts/{boostId}

{
  "caseId": "",
  "userId": "",
  "createdAt": "",
  "expiresAt": "",
  "multiplier": 10
}

# analytics_events

analytics_events/{eventId}

{
  "userId": "",
  "eventName": "",
  "createdAt": "",
  "payload": {}
}

# Feed Query

Collection:

cases

Filters:

status == active

Order:

hotScore DESC

Limit:

20

# Pagination

Cursor Based

startAfter(lastDocument)

# Hot Score Formula

hotScore =

(votesCount * 4)
+ (sharesCount * 6)
+ (savesCount * 2)
+ freshnessBoost

Freshness:

First 3 hours:
+100

First 24 hours:
+25

After 24h:
0

# Firestore Indexes

cases

status ASC
hotScore DESC

cases

category ASC
hotScore DESC

cases

relationshipType ASC
hotScore DESC

notifications

isRead ASC
createdAt DESC

# Security Rules

Users:

Read:
Allowed

Create:
Authenticated only

Update:
Owner only

Delete:
Owner only

# Case Rules

Read:
Anyone

Create:
Authenticated

Update:
Owner only

Delete:
Owner only

# Vote Rules

Create:
Authenticated

One vote per case

Cannot update

Cannot delete

# Report Rules

Authenticated only

One report per case per user

# Premium Rules

Read:
Owner only

Write:
Cloud Functions only

# Ban Logic

If user.isBanned == true

Deny:

Create Case

Vote

Save

Report

Purchase

# Cloud Functions

voteCase()

createCase()

reportCase()

saveCase()

boostCase()

createNotification()

updateHotScore()

# Scheduled Jobs

Every 10 minutes

Recalculate hotScore

Every 1 hour

Expire boosts

Every 24 hours

Clean analytics events

# Denormalization Strategy

Store:

votesCount

sharesCount

reportsCount

inside case document

Avoid expensive aggregations.

# Offline Support

Enable Firestore persistence.

Cached Collections:

cases

notifications

saved_cases

profile

# Database Limits

Description:
500 chars

Question:
100 chars

Display Name:
30 chars

Relationship Type:
20 chars

Category:
30 chars

# Future Collections

comments

blocked_users

appeals

themes

surveys

A/B tests

Not required for MVP.
