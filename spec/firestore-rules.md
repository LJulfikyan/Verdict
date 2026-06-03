# firestore-rules.md
## Verdict – Relationship Jury
### Firestore Security Rules Specification v1.0

# Objectives

- Prevent unauthorized writes
- Prevent vote tampering
- Prevent premium spoofing
- Restrict moderator/admin actions
- Minimize database abuse

# Collections

users
cases
votes
reports
notifications
saved_cases
premium_subscriptions
boosts

# Global Principles

Default:
deny all

Allow only explicitly permitted actions.

# Users Collection

Path:
users/{userId}

Read:
Authenticated users

Create:
Authenticated user creating own document

Update:
Owner only

Delete:
Owner only

Forbidden Fields From Client:

premium
isBanned
trustScore
moderatorRole

# Cases Collection

Path:
cases/{caseId}

Read:
Public

Create:
Authenticated
Not banned

Validation:

relationshipType exists
category exists
description length 50-500
question length 1-100

Update:
Owner only

Allowed Fields:

description
question

Forbidden:

votesCount
hotScore
reportsCount
winnerOption

Delete:
Owner only

# Votes Subcollection

Path:
cases/{caseId}/votes/{userId}

Read:
Owner or Admin

Create:

Authenticated
Not banned
userId == auth.uid

Conditions:

Vote does not already exist

Update:
Never

Delete:
Never

# Reports

Path:
cases/{caseId}/reports/{reportId}

Create:

Authenticated
Not banned

Update:
Never

Delete:
Never

Read:
Moderators/Admins only

# Notifications

Path:
users/{userId}/notifications/{notificationId}

Read:
Owner only

Create:
Server only

Update:
Owner only

Allowed:

isRead

Delete:
Owner only

# Saved Cases

Path:
users/{userId}/saved_cases/{caseId}

Read:
Owner only

Create:
Owner only

Delete:
Owner only

# Premium Subscriptions

Path:
users/{userId}/subscriptions/{subscriptionId}

Read:
Owner only

Write:
Cloud Functions only

Client writes forbidden.

# Boosts

Path:
boosts/{boostId}

Read:
Owner only

Create:
Cloud Functions only

Update:
Cloud Functions only

Delete:
Cloud Functions only

# Admin Roles

Stored:

users/{userId}

Field:

role

Values:

user
moderator
admin

# Moderator Permissions

Can Read:

Reports

Users

Cases

Cannot:

Modify premium

Modify subscriptions

# Admin Permissions

Full access.

# Validation Helpers

isAuthenticated()

isOwner()

isModerator()

isAdmin()

notBanned()

# Rate Limiting Strategy

Enforced in Cloud Functions.

Firestore rules only verify access.

# Protected Fields

Never writable by client:

votesCount
reportsCount
sharesCount
savesCount
hotScore
premium
isBanned
role
trustScore

# Audit Logging

All moderation actions performed via Cloud Functions.

Logged:

moderatorId
action
targetId
timestamp

# Recommended Deployment

dev.rules
staging.rules
prod.rules

# Testing Checklist

User can create case

User cannot edit others

User cannot vote twice

User cannot modify vote

User cannot grant premium

User cannot unban self

Moderator can read reports

Admin has full access

# MVP Rules Scope

Users

Cases

Votes

Reports

Notifications

Saved Cases

Premium

Boosts
