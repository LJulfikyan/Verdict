# architecture.md
## Verdict – Relationship Jury
### Flutter Architecture Specification v1.0

# Architecture Goals

- Feature-first architecture
- Highly scalable
- AI-codegen friendly
- Testable
- Offline tolerant
- Firebase-first

# Tech Stack

Frontend:
- Flutter
- Dart

State Management:
- GetX

Navigation:
- GoRouter

Backend:
- Firebase

Services:
- Firestore
- Firebase Auth
- Firebase Functions
- Firebase Messaging
- Firebase Analytics
- Remote Config
- Crashlytics

Payments:
- RevenueCat

Ads:
- AdMob

# Folder Structure

lib/

core/
  constants/
  theme/
  routes/
  services/
  widgets/
  utils/
  extensions/

data/
  models/
  repositories/
  datasources/

features/
  auth/
  onboarding/
  home/
  create_case/
  notifications/
  profile/
  premium/
  moderation/

# Core Layer

Purpose:
Reusable application-wide components.

Contains:
- Theme
- Colors
- Typography
- Route definitions
- Analytics service
- Notification service
- Ad service

# Feature Pattern

Each feature follows:

feature/
  bindings/
  controllers/
  pages/
  widgets/
  models/
  repositories/

# State Management

GetX only.

Rules:
- One controller per page
- No business logic inside widgets
- No Firestore calls inside UI

UI -> Controller -> Repository -> Firebase

# Navigation

GoRouter

Bottom Tabs:

/home
/create
/inbox
/profile

Authentication:

/welcome
/login

Premium:

/premium

# Dependency Injection

Get.put()

Permanent Services:

- AuthService
- AnalyticsService
- NotificationService
- AdService
- RevenueCatService

# Repository Layer

Purpose:

Abstract Firebase.

Example:

CaseRepository

Methods:

createCase()
getFeed()
vote()
reportCase()
saveCase()

# Models

UserModel

CaseModel

VoteModel

ReportModel

NotificationModel

PremiumPlanModel

# Feed Architecture

Firestore collection:

cases

Pagination:

Cursor based

Order:

hotScore DESC

Page size:

20

# Vote Flow

User taps vote

Controller:
vote()

Repository:
submitVote()

Firestore:
transaction

Update:

votesCount

results

userVote

# Home Controller

Responsibilities:

- Load feed
- Refresh feed
- Pagination
- Vote handling
- Save case
- Share case

# Create Case Controller

Responsibilities:

- Form state
- Validation
- Submission

# Profile Controller

Responsibilities:

- User profile
- Statistics
- Premium status

# Notification Controller

Responsibilities:

- Load notifications
- Mark read
- Open target screen

# Offline Strategy

Firestore cache enabled.

Feed:

show cached data immediately.

Refresh in background.

# Error Handling

Global Error Handler

Levels:

- Network
- Firebase
- Validation
- Unknown

User Messages:

Short only.

Examples:

Something went wrong.

Please try again.

# Loading States

Never use fullscreen spinners.

Use:

- Skeletons
- Shimmer
- Button loading states

# Analytics Architecture

Every action tracked.

Examples:

app_open

case_view

case_vote

case_create

premium_open

premium_purchase

boost_purchase

# Ad Architecture

Native Ads:

Inserted every 10 feed items.

Interstitial:

Every 50 votes.

Premium users:

No ads.

# Push Notifications

Firebase Messaging

Events:

- Case trending
- Case milestones
- Premium promotions

# Security Rules Strategy

Users can:

create own cases

read active cases

vote once

report once

cannot edit others

# Testing

Unit Tests:

Repositories
Controllers

Widget Tests:

Vote Card
Create Case Flow

Integration Tests:

Login
Create Case
Vote Flow

# Performance Targets

Cold Start:
< 2 seconds

Feed Load:
< 1 second cached

Vote Action:
< 300ms

FPS:
60+

# Release Process

Development

Staging

Production

Separate Firebase projects.

# MVP Architecture Summary

Frontend:
Flutter + GetX + GoRouter

Backend:
Firebase

Monetization:
RevenueCat + AdMob

Pattern:
Feature-first architecture

Data Flow:

UI
→ Controller
→ Repository
→ Firebase
→ Repository
→ Controller
→ UI
