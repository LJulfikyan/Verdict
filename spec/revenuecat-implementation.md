# revenuecat-implementation.md
## Verdict – Relationship Jury
### RevenueCat Subscription Architecture v1.0

# Purpose

RevenueCat is the source of truth for:

- Premium status
- Subscription validation
- Renewals
- Cancellations
- Expirations
- Restores

# Providers

Apple App Store

Google Play

# Product IDs

Monthly:

verdict_premium_monthly

Yearly:

verdict_premium_yearly

# Entitlement

Name:

premium

Rule:

If entitlement active → user premium

# Architecture

RevenueCat

↓

Webhook

↓

Firebase Function

↓

Firestore

↓

Flutter App

# Flutter Packages

purchases_flutter

# Startup Flow

App Launch

↓

Initialize RevenueCat

↓

Fetch CustomerInfo

↓

Check premium entitlement

↓

Update PremiumService

# PremiumService

Responsibilities:

Initialize SDK

Load offerings

Purchase package

Restore purchases

Monitor entitlement changes

# Initialization

Execute once.

Environment:

Production

Sandbox

# Offerings

Default Offering

Contains:

Monthly

Yearly

# Pricing Cards

Monthly

Price from RevenueCat

Do not hardcode.

Yearly

Price from RevenueCat

Do not hardcode.

# Purchase Flow

User taps:

Upgrade

↓

RevenueCat purchase()

↓

Success

↓

Entitlement active

↓

Premium enabled

# Failed Purchase Flow

Show:

Purchase Failed

Try Again

Cancel

# Restore Flow

Button:

Restore Purchases

↓

RevenueCat.restorePurchases()

↓

Refresh CustomerInfo

↓

Update entitlement

# CustomerInfo

Source of truth on device.

Fields:

activeSubscriptions

entitlements

expirationDate

# Firestore Sync

Collection:

users/{userId}

Fields:

premium

subscriptionPlan

subscriptionExpiresAt

lastSubscriptionSync

# Webhook Events

INITIAL_PURCHASE

RENEWAL

PRODUCT_CHANGE

EXPIRATION

CANCELLATION

BILLING_ISSUE

TRANSFER

# Webhook Endpoint

Firebase Function

/revenuecat/webhook

# Webhook Validation

Verify RevenueCat signature.

Reject invalid requests.

# INITIAL_PURCHASE

Actions:

Enable premium

Store plan

Store expiration

Create analytics event

# RENEWAL

Actions:

Update expiration

Track renewal

# EXPIRATION

Actions:

Disable premium

Remove entitlement

Track churn

# CANCELLATION

Actions:

Keep premium until expiration

Mark cancelledAt

# BILLING_ISSUE

Actions:

Flag account

Notify user

# Transfer Event

Handle account migration.

# Premium Access Rules

Premium users:

No Ads

Advanced Demographics

Advanced Analytics

Custom Themes

Priority Support

# Premium Gates

Feature Check:

PremiumService.isPremium

# UI Behavior

Premium Disabled

Show paywall.

Premium Enabled

Show content.

# Remote Config Integration

Variables:

premium_enabled

monthly_discount

yearly_discount

# Analytics Events

premium_screen_open

premium_purchase_started

premium_purchase_success

premium_purchase_failed

premium_restore_started

premium_restore_success

premium_restore_failed

# Event Parameters

plan_type

price

currency

store

country

# Paywall Screen

Sections:

Header

Benefits

Pricing Cards

CTA

Restore Purchases

FAQ

# Pricing Card State

selected

unselected

loading

# Churn Tracking

Track:

Cancellation Rate

Expiration Rate

Renewal Rate

# KPIs

Premium Conversion

Subscription Retention

MRR

ARR

Revenue Per Paying User

# Security

Never trust:

Local premium flag

Always verify:

RevenueCat entitlement

Webhook updates

# Offline Behavior

Last known entitlement cached.

Temporary access allowed.

Force refresh on reconnect.

# Error Handling

Network Error

Store Error

Purchase Cancelled

Product Unavailable

Unknown Error

# Testing Scenarios

Purchase Monthly

Purchase Yearly

Restore Purchase

Renew Subscription

Expire Subscription

Cancel Subscription

Billing Failure

# Sandbox Testing

Apple Sandbox

Google License Testers

# Future Features

Lifetime Plan

Trial Periods

Promotional Offers

Win-back Campaigns

Not MVP.

# MVP Scope

Monthly Plan

Yearly Plan

Restore Purchases

RevenueCat Webhooks

Entitlement Sync

Premium Gates

Analytics

Security Validation
