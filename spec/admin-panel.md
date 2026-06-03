# admin-panel.md
## Verdict – Relationship Jury
### Admin & Moderator Dashboard Specification v1.0

# Purpose

The Admin Panel is a private web application used to:

- Moderate content
- Manage users
- Review reports
- Track revenue
- Monitor growth
- Manage platform settings

Platform:

Flutter Web

Authentication:

Admin Accounts Only

# Roles

Admin

Moderator

Support

# Permissions Matrix

Admin:
- Full Access

Moderator:
- Content Moderation
- User Actions

Support:
- Read Only
- User Lookup

# Login Screen

Fields:

Email

Password

Button:

Login

Requirements:

2FA

Whitelisted Accounts

# Dashboard Home

Widgets:

DAU

MAU

Revenue

Cases Today

Votes Today

Reports Today

Premium Subscribers

# Dashboard Navigation

Overview

Cases

Users

Reports

Revenue

Analytics

Notifications

Settings

Audit Logs

# Overview Screen

Cards:

Daily Active Users

Monthly Active Users

Total Cases

Total Votes

Total Revenue

Active Premium Users

# Charts

User Growth

Revenue Growth

Case Growth

Vote Growth

# Cases Screen

Table Columns:

Case ID

Author

Category

Votes

Reports

Status

Created At

# Filters

Active

Hidden

Deleted

Trending

Reported

# Case Detail Screen

Display:

Relationship Type

Category

Description

Question

Vote Breakdown

Reports

# Actions

Hide

Delete

Restore

Warn User

Ban User

# Reports Screen

Columns:

Report ID

Case ID

Reason

Reporter

Created At

# Filters

Spam

Harassment

Personal Information

Violence

Other

# Report Detail

Display:

Case Content

Report History

Reporter Count

# Actions

Dismiss

Hide Case

Delete Case

Warn User

Suspend User

# Users Screen

Columns:

User ID

Display Name

Premium

Cases

Votes

Trust Score

Created At

# User Detail

Profile

Statistics

Reports

Moderation History

Purchases

# Actions

Warn

Suspend

Ban

Delete Account

Grant Premium

Remove Premium

# Moderation Actions

Warning

3 Day Suspension

30 Day Suspension

Permanent Ban

# Revenue Screen

Cards:

Today's Revenue

Monthly Revenue

Annual Revenue

ARPU

MRR

ARR

# Revenue Breakdown

Ads

Premium

Boosts

# Premium Subscribers Table

User

Plan

Started

Expires

Status

# Analytics Screen

Charts:

DAU

MAU

Retention

Revenue

Case Creation

Voting Activity

# Filters

7 Days

30 Days

90 Days

365 Days

# Notifications Screen

Create Broadcast

Fields:

Title

Message

Target Audience

# Audience Filters

All Users

Premium Users

Free Users

Active Users

Inactive Users

# Broadcast Types

Push

Inbox

Both

# Settings Screen

Remote Config Values

Ad Frequency

Premium Pricing

Boost Pricing

Feature Flags

# Feature Flags

Enable Premium

Enable Ads

Enable Boosts

Enable Notifications

Maintenance Mode

# Maintenance Mode

When Enabled:

Users see maintenance screen.

Admins still access panel.

# Audit Logs

Columns:

Admin

Action

Target

Timestamp

# Logged Actions

Hide Case

Delete Case

Ban User

Grant Premium

Broadcast Sent

Settings Changed

# Search

Global Search

Search:

Case ID

User ID

Display Name

# Exporting

CSV Export

Users

Revenue

Cases

Reports

# Security

2FA Required

Session Timeout:

30 Minutes

# Session Handling

Auto Logout:

After inactivity

# Error States

Permission Denied

Network Error

Unknown Error

# Performance Targets

Dashboard Load:
<2s

Case Search:
<500ms

User Search:
<500ms

# MVP Scope

Required:

Overview

Cases

Reports

Users

Revenue

Analytics

Settings

Audit Logs

Moderator Actions

Admin Authentication
