# monetization.md
## Verdict – Relationship Jury
### Monetization Strategy & Revenue Specification v1.0

# Revenue Philosophy

Primary Goal:

Generate revenue without harming retention.

Priority:

1. Ads
2. Premium Subscription
3. Case Boosts

# Revenue Streams

Ads

Premium

Boosts

Future:
Sponsored Cases
Brand Surveys

# AdMob Integration

Provider:

Google AdMob

# Native Feed Ads

Placement:

Every 10 feed cards

Pattern:

9 cases

1 ad

9 cases

1 ad

Requirements:

Must visually differ from cases.

Label:

Sponsored

# Native Ad Layout

Title

Description

CTA Button

Advertiser Badge

Max Height:

140

# Interstitial Ads

Trigger:

Every 50 votes

Limits:

Maximum 3/day

Minimum interval:

30 minutes

# Rewarded Ads

Use Cases:

Unlock demographics

Unlock advanced results

Unlock extra statistics

Reward:

Temporary access

Duration:

24 hours

# Premium Subscription

Provider:

RevenueCat

# Plans

Monthly

$4.99

Yearly

$39.99

# Premium Benefits

No ads

Advanced demographics

Relationship insights

Early access features

Custom themes

Priority support

Premium badge

# Premium Screen

Sections:

Header

Benefits

Plans

FAQ

Purchase Button

Restore Purchases

# Premium Demographics

Breakdown:

Gender

Age Range

Country

Relationship Status

Premium Only

# Premium Analytics

Show:

Average agreement score

Case performance

Engagement trends

Top categories

# Relationship Insights

Example:

People agree with you 73% of the time.

Most disagreements occur in Family category.

# Boosts

Purpose:

Increase visibility of case.

# Boost Pricing

Starter

$0.99

24h

Multiplier 10x

---

Popular

$2.99

48h

Multiplier 25x

---

Max

$4.99

72h

Multiplier 50x

# Boost Rules

Only author can boost.

Cannot boost deleted case.

Cannot stack boosts.

# Boost Badge

Displayed on card:

Trending

or

Boosted

# Share Monetization

When user shares:

Track:

shareCount

High share cases gain additional hotScore.

# Referral Program

Future Feature

Invite user

Reward:

Premium days

Not MVP.

# Sponsored Surveys

Future Feature

Companies pay to ask:

"What do women think about..."

Marked:

Sponsored

Not MVP.

# Sponsored Cases

Future Feature

Brand-created relationship scenarios.

Not MVP.

# RevenueCat Events

INITIAL_PURCHASE

RENEWAL

EXPIRATION

CANCELLATION

BILLING_ISSUE

# Purchase Flow

User taps:

Upgrade

↓

RevenueCat Paywall

↓

Success

↓

Premium Activated

# Failed Purchase Flow

Show:

Purchase Failed

Try Again

# Restore Purchases

Required

Available from:

Premium Screen

Settings

# Subscription Status

Stored:

Firestore

RevenueCat

# Premium Badge

Displayed:

Profile

Case author card

# Ad Removal Logic

Premium users:

Never see ads

Includes:

Native

Interstitial

Rewarded optional

# Pricing Experiments

Remote Config

Variables:

monthly_price

yearly_price

discount_enabled

# Revenue Analytics

Track:

Ad impressions

Ad clicks

Premium opens

Premium purchases

Boost purchases

Conversion rates

# KPIs

Ad ARPDAU

Premium Conversion

Boost Conversion

Subscription Retention

Revenue Per User

# Expected Revenue Mix

Early Stage

Ads 90%

Premium 8%

Boosts 2%

---

Growth Stage

Ads 70%

Premium 20%

Boosts 10%

---

Mature Stage

Ads 50%

Premium 30%

Boosts 20%

# Revenue Dashboard

Admin Metrics:

Daily Revenue

Monthly Revenue

Premium Users

Active Subscriptions

Boost Purchases

Ad Revenue

# Refund Handling

RevenueCat source of truth.

Subscription revoked:

Premium disabled immediately.

# Future Revenue Ideas

Theme Marketplace

Custom Profile Themes

Relationship Reports

Advanced Insights

Sponsored Content

Not MVP.

# MVP Monetization Scope

Required:

Native Ads

Interstitial Ads

Monthly Premium

Yearly Premium

Case Boosts

Revenue Analytics

Everything else deferred.
