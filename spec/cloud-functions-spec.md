# cloud-functions-spec.md
## Verdict – Relationship Jury
### Firebase Cloud Functions Specification v1.0

# Architecture

Runtime:
Firebase Functions v2

Language:
TypeScript

Region:
us-central1

Authentication:
Firebase Auth Required

# Folder Structure

functions/

src/

auth/
cases/
votes/
reports/
notifications/
premium/
boosts/
analytics/
admin/
shared/

# Shared Middleware

authenticateUser()

verifyNotBanned()

validatePayload()

rateLimit()

auditLog()

# Function: createCase

Type:
Callable Function

Path:
cases/createCase

Input:

{
  "relationshipType": "",
  "category": "",
  "description": "",
  "question": ""
}

Validation:

relationshipType required

category required

description 50-500 chars

question 1-100 chars

Actions:

Create case

Initialize counters

Create analytics event

Response:

{
  "success": true,
  "caseId": ""
}

# Function: updateCase

Restrictions:

Owner only

Editable Fields:

description

question

Cannot Edit:

votes

category

relationshipType

# Function: deleteCase

Owner only

Behavior:

Soft delete

status = deleted

# Function: voteCase

Callable

Input:

{
  "caseId": "",
  "option": ""
}

Validation:

Authenticated

Case exists

Case active

User has not voted

Transaction:

Create vote document

Increment vote counter

Increment votesCount

Recalculate winnerOption

Update hotScore

Analytics event

Response:

{
  "success": true
}

# Function: saveCase

Toggle save state.

Updates:

saved_cases

savesCount

Analytics

# Function: shareCase

Updates:

sharesCount

hotScore

Analytics

# Function: reportCase

Input:

{
  "caseId": "",
  "reason": ""
}

Create report.

Increment reportsCount.

If reports >= threshold:

status = hidden

Create moderator notification.

# Function: boostCase

Validation:

Payment completed

Case active

User owns case

Actions:

Create boost

Set multiplier

Set expiration

Recalculate hotScore

# Function: createNotification

Internal only.

Input:

userId

title

body

type

targetId

# Function: markNotificationRead

Owner only.

Updates:

isRead = true

# Function: deleteAccount

Actions:

Delete notifications

Delete saved cases

Anonymize cases

Delete user profile

# Function: updateProfile

Editable:

displayName

country

gender

ageRange

# Function: getPremiumStatus

Returns:

active

plan

expiresAt

# Function: grantPremium

Admin only.

# Function: revokePremium

Admin only.

# RevenueCat Webhooks

INITIAL_PURCHASE

RENEWAL

EXPIRATION

CANCELLATION

BILLING_ISSUE

Actions:

Update Firestore

Create analytics event

# Scheduled Function

recalculateHotScores

Frequency:

10 minutes

Formula:

(votesCount * 4)
+ (sharesCount * 6)
+ (savesCount * 2)

Apply boost multiplier

# Scheduled Function

expireBoosts

Frequency:

Hourly

Actions:

Disable boost

Recalculate hotScore

# Scheduled Function

cleanupAnalytics

Frequency:

Daily

Retention:

12 months

# Firestore Triggers

onCaseCreated

onVoteCreated

onReportCreated

onSubscriptionChanged

# Trigger: onVoteCreated

Actions:

Check milestones

100 votes

500 votes

1000 votes

5000 votes

Create notifications

# Trigger: onCaseCreated

Analytics

Feed indexing

# Trigger: onReportCreated

Check threshold

Notify moderators

# Trigger: onSubscriptionChanged

Update premium flag

# Rate Limits

createCase:
5/day

voteCase:
500/day

reportCase:
50/day

boostCase:
20/day

# Audit Logs

Every admin action stored.

Fields:

adminId

action

targetId

timestamp

# Error Response

{
  "success": false,
  "error": {
    "code": "",
    "message": ""
  }
}

# Logging

Use:

logger.info

logger.warn

logger.error

Never log:

Tokens

Payment data

Personal information

# Environment Variables

RevenueCat Keys

AdMob Config

Feature Flags

Notification Settings

# Deployment Environments

Development

Staging

Production

Separate Firebase projects.

# Unit Testing

Functions:

createCase

voteCase

reportCase

boostCase

premium webhooks

# MVP Scope

Required:

createCase

voteCase

saveCase

reportCase

boostCase

notifications

premium webhooks

scheduled jobs

audit logs
