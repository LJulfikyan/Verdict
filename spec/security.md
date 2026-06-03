# security.md
## Verdict – Relationship Jury
### Security, Privacy & Compliance Specification v1.0

# Security Goals

- Protect user identity
- Prevent vote manipulation
- Prevent account abuse
- Protect revenue
- Protect platform integrity

# Threat Model

Primary Threats:

- Fake accounts
- Vote farming
- Spam
- Data leaks
- Premium abuse
- Account takeover
- API abuse

# Authentication

Providers:

Google

Apple

Guest

No email/password in MVP.

# Authentication Rules

All protected actions require:

Authenticated user

Protected Actions:

Create Case

Vote

Save

Report

Purchase

# Guest Users

Allowed:

Browse feed

View cases

View results

Not Allowed:

Vote

Create

Save

Report

Purchase

# Firebase Security

Enable:

App Check

Providers:

Play Integrity

Apple Device Check

# JWT Validation

All cloud functions verify:

Firebase ID Token

User exists

User not banned

# Firestore Security Rules

Users:

Read:
Authenticated

Update:
Owner only

Delete:
Owner only

# Cases

Read:
Public

Create:
Authenticated

Update:
Owner only

Delete:
Owner only

# Votes

Create:
Authenticated

Read:
Restricted

Update:
Never

Delete:
Never

# Reports

Create:
Authenticated

Read:
Moderator/Admin

# Premium

Write:
Server only

Read:
Owner

# Anti Spam Rules

Case Creation:

Maximum:
5/day

Vote:

Maximum:
500/day

Reports:

Maximum:
50/day

# Vote Manipulation Prevention

Track:

User ID

Device

IP hash

Creation date

Vote velocity

# Suspicious Signals

Account age < 1 day

Hundreds of votes

Repeated voting patterns

Large IP clusters

# Account Security

Google:
Managed by Google

Apple:
Managed by Apple

Guest:
Local device identity

# Account Deletion

User can request deletion.

Process:

Delete profile

Delete notifications

Delete saved cases

Anonymize authored cases

# Data Retention

Analytics:
12 months

Notifications:
12 months

Reports:
24 months

Cases:
Indefinite

# Privacy Rules

Never collect:

Phone number

Address

Contacts

Photos

Microphone

Location

SMS

# User Data Stored

User ID

Display Name

Country

Premium Status

Statistics

# Legal Compliance

Support:

GDPR

CCPA

Basic privacy requests

# User Rights

View data

Delete account

Request deletion

Export data (future)

# Encryption

In Transit:

HTTPS/TLS

At Rest:

Firebase managed encryption

# Secrets

Store in:

Firebase Secret Manager

Never:

Hardcode secrets

# API Protection

All Functions:

Authentication required

Rate limited

Validated

# Revenue Protection

RevenueCat is source of truth.

Never trust client purchase state.

# Premium Validation

Client:

Display only

Server:

Verification

Access control

# Ad Fraud Prevention

Track:

Impressions

Clicks

CTR

Invalid traffic

# Logging

Log:

Security events

Moderation actions

Purchase events

# Never Log

Tokens

Personal data

Payment details

# Monitoring

Firebase Crashlytics

Cloud Logging

Analytics Alerts

# Security Alerts

Notify Admin If:

Vote spike

Mass account creation

Abnormal purchases

Report spam

# Moderator Security

Role Based Access

Roles:

Moderator

Admin

# Admin Security

2FA Required

Admin email whitelist

# Device Security

Future:

Device fingerprinting

Risk scoring

Not MVP.

# Abuse Prevention

Automatic temporary lock:

Excessive reports

Excessive votes

Spam creation

# Content Privacy

No public profile browsing.

No follower system.

No direct messaging.

# Backup Strategy

Firestore Export

Daily

Retention:

30 days

# Disaster Recovery

Restore latest backup

Restore users

Restore cases

Restore subscriptions

# Security KPIs

Fraud Rate:
<1%

Unauthorized Access:
0

Successful Purchase Validation:
100%

Crash Free Users:
99%+

# MVP Security Scope

Required:

Firebase Auth

App Check

Firestore Rules

Cloud Function Validation

Rate Limiting

Purchase Verification

Account Deletion

Privacy Settings
