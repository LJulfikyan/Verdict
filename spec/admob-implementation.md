# admob-implementation.md
## Verdict – Relationship Jury
### AdMob Architecture & Advertising Strategy v1.0

# Objectives

- Maximize revenue
- Protect retention
- Protect session length
- Avoid user frustration
- Preserve voting flow

# Ad Provider

Primary:

Google AdMob

Future:

Mediation

# Ad Types

Native Ads

Interstitial Ads

Rewarded Ads

# Ad Philosophy

Ads must never interrupt:

- Case creation
- Voting submission
- Purchase flow
- Login flow

# Native Feed Ads

Primary revenue source.

Placement:

Every 10 feed cards

Pattern:

9 cases

1 ad

9 cases

1 ad

# Native Ad Design

Height:

120-140

Elements:

Headline

Description

CTA

Sponsored Label

Advertiser Name

# Native Ad Rules

Must clearly show:

Sponsored

Must visually differ from cases.

# Feed Injection Logic

Feed Items:

Case
Case
Case
Case
Case
Case
Case
Case
Case
Ad

Repeat.

# Native Ad Loading

Preload:

3 ads ahead

Fallback:

Remove slot if unavailable

# Interstitial Ads

Secondary revenue source.

Trigger:

After 50 votes

# Frequency Caps

Max:

3 per day

Minimum Interval:

30 minutes

# Interstitial Rules

Never show:

Immediately after launch

Immediately after login

Immediately after purchase

Immediately after case submission

# Recommended Timing

After vote completed

Before loading next batch of feed items

# Rewarded Ads

Purpose:

Unlock premium-like features temporarily

# Reward Options

Demographic breakdown

Advanced verdict analytics

Relationship insights

# Reward Duration

24 hours

# Reward Flow

Watch Ad

↓

Reward Granted

↓

Feature Enabled

# Premium Interaction

Premium users:

No Native Ads

No Interstitial Ads

Rewarded Ads optional

# Ad Service

Responsibilities:

Initialize SDK

Load ads

Show ads

Track impressions

Track clicks

Handle failures

# AdController

Reactive Variables:

nativeAdsLoaded

canShowInterstitial

rewardReady

# Startup Flow

App Launch

↓

Initialize AdMob

↓

Preload Native Ads

↓

Preload Interstitial

# Ad Unit IDs

Development:

Google Test IDs

Production:

AdMob IDs

Never hardcode production IDs in source control.

# Ad Placement IDs

feed_native

vote_interstitial

rewarded_demographics

rewarded_insights

# Analytics Events

ad_loaded

ad_failed

ad_impression

ad_clicked

reward_started

reward_completed

# Event Parameters

placement

ad_type

network

estimated_revenue

# Revenue Tracking

Metrics:

Impressions

Clicks

CTR

eCPM

ARPDAU

# Dashboard KPIs

Ad Revenue

Impressions

CTR

eCPM

ARPDAU

# Ad Loading Strategy

Native:

Preload

Interstitial:

Preload

Rewarded:

Load on demand

# Error Handling

If ad fails:

Continue user flow

Never block content.

# Fill Rate Protection

If no ad available:

Skip placement

Show next case

# Retention Protection Rules

No full screen ads:

First session

First day

First 20 votes

# New User Experience

Day 0:

Native Ads only

No interstitials

# Returning Users

Standard ad frequency applies.

# Ad Frequency Experiments

Remote Config

Variables:

native_interval

interstitial_vote_count

max_interstitials_per_day

# Suggested Defaults

Native:

Every 10 cards

Interstitial:

Every 50 votes

Daily Cap:

3

# Ad Fraud Monitoring

Track:

CTR spikes

Impression spikes

Abnormal click patterns

# Invalid Traffic Signals

Repeated device clicks

Repeated IP clicks

Very high CTR

# Premium Upsell Logic

If user closes interstitial:

Occasionally show:

Upgrade to remove ads

Frequency:

Max once per week

# Mediation (Future)

Networks:

Meta Audience Network

AppLovin

Unity Ads

IronSource

# Regional Optimization

Different ad frequencies per country.

Controlled by Remote Config.

# Compliance

Follow:

Google AdMob Policies

App Store Policies

Play Store Policies

# Testing Checklist

Native Ad Load

Native Ad Failure

Interstitial Frequency

Rewarded Reward Delivery

Premium Ad Removal

Analytics Events

# MVP Scope

Native Feed Ads

Interstitial Ads

Rewarded Ads

Premium Ad Removal

Analytics

Remote Config Controls
