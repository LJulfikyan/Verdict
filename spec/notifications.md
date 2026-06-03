# notifications.md
## Verdict – Relationship Jury
### Push Notifications & Engagement Specification v1.0

# Purpose

Notifications exist to:

- Increase retention
- Increase voting activity
- Increase case creation
- Increase premium conversions
- Bring users back daily

Provider:

Firebase Cloud Messaging (FCM)

# Notification Categories

1. Case Milestones
2. Trending Cases
3. Engagement
4. Premium
5. System
6. Moderation

# User Preferences

Settings:

Enable All

Case Activity

Trending Cases

Premium Offers

System Notifications

# Case Milestone Notifications

Trigger:

100 votes

Example:

Your case reached 100 votes.

---

Trigger:

500 votes

Example:

Your case reached 500 votes.

---

Trigger:

1000 votes

Example:

Your case reached 1,000 votes.

---

Trigger:

5000 votes

Example:

Your case is going viral.

# Trending Notifications

Trigger:

Case enters trending feed.

Example:

Your case is trending right now.

# Vote Split Notifications

Trigger:

Significant disagreement.

Example:

Men and women strongly disagree on your case.

# Save Milestone Notifications

Trigger:

50 saves

Example:

50 people saved your case.

# Share Milestone Notifications

Trigger:

25 shares

Example:

Your case is being shared across the platform.

# Daily Engagement Notifications

Frequency:

Maximum 1/day

Examples:

New relationship cases need your verdict.

The jury is waiting for your vote.

Popular cases are trending right now.

# Personalized Engagement

Based on categories.

Examples:

New Family cases available.

New Jealousy cases available.

# Re-Engagement Campaigns

Inactive 3 Days

Example:

You missed several trending verdicts.

---

Inactive 7 Days

Example:

The jury needs your opinion.

---

Inactive 14 Days

Example:

Come back and see what changed.

# Premium Notifications

Trigger:

Premium screen viewed but not purchased.

Example:

Remove ads and unlock demographics.

Cooldown:

7 days

# Boost Notifications

Trigger:

User created case but engagement low.

Example:

Boost your case and reach more jurors.

# Moderation Notifications

Case Hidden

Example:

Your case has been hidden pending review.

---

Warning Issued

Example:

Your account received a warning.

---

Suspension

Example:

Your account has been suspended.

# System Notifications

Examples:

New app version available.

Maintenance completed.

Important policy update.

# Deep Linking

Every notification opens specific screen.

Examples:

caseId

profile

premium

settings

# Notification Payload

{
  "title": "",
  "body": "",
  "type": "",
  "targetId": "",
  "createdAt": ""
}

# Notification Types

case_milestone

case_trending

daily_engagement

premium_offer

boost_offer

moderation

system

# Inbox Screen

Sections:

Unread

Read

# Notification Card

Title

Description

Time

Chevron

# Read State

Unread:

Bold

Read:

Normal

# Inbox Actions

Open

Delete

Mark Read

Mark All Read

# Notification Limits

Case Milestones:
Unlimited

Engagement:
1/day

Premium:
1/week

Boost:
1/week

System:
As needed

# Smart Delivery Rules

Do Not Send If:

User opened app within last 4 hours.

User disabled notifications.

User banned.

# Delivery Windows

Preferred:

09:00–22:00 local time

Avoid:

23:00–08:00

# Analytics Events

notification_received

notification_opened

notification_dismissed

notification_converted

# KPIs

Delivery Rate:
95%+

Open Rate:
15%+

CTR:
8%+

Return Rate:
10%+

# Future Features

Notification Categories Subscription

Trending Category Alerts

Premium Exclusive Alerts

Not MVP.

# MVP Scope

Required:

Milestone Notifications

Trending Notifications

Daily Engagement

Moderation Notifications

System Notifications

Inbox Screen

Notification Preferences
