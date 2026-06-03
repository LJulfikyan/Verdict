# analytics.md
## Verdict – Relationship Jury
### Analytics & Growth Tracking Specification v1.0

# Purpose

Analytics exists to answer:

- Why users stay
- Why users leave
- What generates revenue
- What drives virality
- What improves retention

Provider:

Firebase Analytics

# User Lifecycle Funnel

Install

→ Open App

→ Complete Onboarding

→ Sign In

→ View Feed

→ Vote

→ Create Case

→ Return Next Day

# Core Metrics

DAU

MAU

DAU / MAU Ratio

D1 Retention

D7 Retention

D30 Retention

Average Session Length

Average Votes Per User

Average Cases Per User

# Event Naming Convention

snake_case

Examples:

app_open

case_view

case_vote

case_create

# User Properties

user_id

premium_status

country

age_range

gender

account_age_days

cases_count

votes_count

# Authentication Events

login_google

login_apple

login_guest

account_deleted

# Onboarding Events

onboarding_started

onboarding_completed

onboarding_skipped

# Feed Events

feed_open

feed_refresh

feed_scroll

feed_end_reached

# Case Events

case_view

Parameters:

case_id

category

relationship_type

author_id

# Vote Events

case_vote

Parameters:

case_id

vote_option

relationship_type

category

# Vote Metrics

Track:

Votes Per Session

Votes Per User

Votes Per Day

Vote Completion Rate

# Create Case Events

case_create_started

case_create_step_1

case_create_step_2

case_create_step_3

case_create_step_4

case_created

# Create Case Parameters

relationship_type

category

description_length

question_length

# Create Funnel

Started

→ Completed

Measure drop-off per step.

# Save Events

case_saved

case_unsaved

# Share Events

case_shared

Parameters:

case_id

share_target

# Share Targets

system_share

whatsapp

telegram

instagram

other

# Virality Metrics

Share Rate

Shares Per Case

Shares Per User

K-Factor

Invite Conversion

# Notification Events

notification_received

notification_opened

notification_dismissed

# Notification KPIs

Open Rate

CTR

Return Rate

# Profile Events

profile_open

settings_open

premium_banner_clicked

# Premium Events

premium_screen_open

premium_purchase_started

premium_purchase_success

premium_purchase_failed

premium_restored

# Premium Parameters

plan_type

price

currency

# Revenue Metrics

MRR

ARR

Revenue Per User

Revenue Per Paying User

Premium Conversion Rate

Subscription Retention

# Ad Events

ad_impression

ad_click

ad_reward_claimed

# Ad Parameters

placement

ad_type

revenue_estimate

# Ad Placements

feed_native

interstitial_vote

rewarded_demographics

# Boost Events

boost_open

boost_purchase_started

boost_purchase_success

boost_purchase_failed

# Boost Parameters

boost_plan

duration_hours

multiplier

price

# Moderation Events

report_case

report_reason

case_hidden

user_suspended

user_banned

# Retention Metrics

D1

D7

D14

D30

D60

D90

# Engagement Metrics

Daily Votes

Daily Cases

Feed Depth

Session Duration

Sessions Per User

# Growth Dashboard

Track:

Installs

DAU

MAU

Retention

Revenue

Shares

# Product Dashboard

Track:

Cases Created

Votes Submitted

Reports Submitted

Feed Views

Notification Opens

# Revenue Dashboard

Track:

Ad Revenue

Subscription Revenue

Boost Revenue

Total Revenue

# Cohort Analysis

Group Users By:

Install Date

Country

Gender

Premium Status

# A/B Testing Support

Remote Config

Experiments:

Ad Frequency

Premium Pricing

Vote Button Labels

Feed Ranking

# KPI Targets

D1 Retention:
40%

D7 Retention:
20%

D30 Retention:
10%

Average Session:
8 Minutes

Votes/User/Day:
15

# Alerting

Trigger Alert If:

DAU drops >20%

Revenue drops >20%

Crash Rate >2%

Retention drops >10%

# Crashlytics Metrics

Track:

Crash Free Users

Crash Free Sessions

Fatal Errors

ANRs

# MVP Analytics Scope

Required:

Authentication Events

Feed Events

Vote Events

Create Events

Premium Events

Ad Events

Boost Events

Retention Tracking

Revenue Tracking
