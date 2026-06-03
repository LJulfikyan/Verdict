# getx-state-map.md
## Verdict – Relationship Jury
### GetX State Management Architecture v1.0

# Goals

- Single source of truth
- Reactive UI
- Clear ownership of state
- No business logic in widgets
- Predictable lifecycle

# Global Services

Registered at app startup.

AuthService
AnalyticsService
NotificationService
AdService
PremiumService
RemoteConfigService

Registration:

Get.put(..., permanent: true)

# Bindings Structure

Each feature owns its binding.

Example:

HomeBinding

CreateCaseBinding

ProfileBinding

PremiumBinding

# AuthController

Purpose:

Manage authentication state.

Reactive Variables:

isLoading

currentUser

isGuest

isAuthenticated

Methods:

loginGoogle()

loginApple()

continueAsGuest()

logout()

deleteAccount()

Lifecycle:

onInit()

listenAuthChanges()

# Auth State Flow

Firebase Auth

→ AuthService

→ AuthController

→ UI

# OnboardingController

Reactive Variables:

currentPage

isLastPage

Methods:

nextPage()

previousPage()

completeOnboarding()

# HomeController

Purpose:

Feed management

Reactive Variables:

feedItems

isLoading

isRefreshing

hasMore

selectedCase

Methods:

loadFeed()

refreshFeed()

loadMore()

vote()

saveCase()

shareCase()

openCase()

# Feed State Model

enum FeedState

loading

success

empty

error

# Feed Lifecycle

onInit()

loadFeed()

onClose()

dispose listeners

# Vote State

Reactive:

selectedVote

isVoting

voteResult

Methods:

submitVote()

# Vote Flow

UI

→ HomeController.vote()

→ Repository

→ Cloud Function

→ Update feedItems

→ Refresh UI

# CreateCaseController

Purpose:

Multi-step creation flow

Reactive Variables:

currentStep

relationshipType

category

description

question

isSubmitting

Methods:

nextStep()

previousStep()

submitCase()

validateStep()

# Validation State

isRelationshipValid

isCategoryValid

isDescriptionValid

isQuestionValid

# Create Flow Lifecycle

Reset state after successful submit.

# NotificationsController

Reactive Variables:

notifications

unreadCount

isLoading

Methods:

loadNotifications()

markRead()

markAllRead()

deleteNotification()

# ProfileController

Reactive Variables:

profile

statistics

savedCases

isLoading

Methods:

loadProfile()

loadStatistics()

loadSavedCases()

updateProfile()

# Statistics Model

casesPosted

votesReceived

agreementScore

savedCount

# PremiumController

Reactive Variables:

plans

selectedPlan

isLoading

purchaseInProgress

isPremium

Methods:

loadPlans()

purchase()

restorePurchases()

# Premium State Flow

RevenueCat

→ PremiumService

→ PremiumController

→ UI

# SettingsController

Reactive Variables:

notificationsEnabled

darkMode

language

Methods:

toggleNotifications()

toggleTheme()

changeLanguage()

# ReportController

Reactive Variables:

selectedReason

isSubmitting

Methods:

selectReason()

submitReport()

# NotificationBadgeController

Reactive Variables:

unreadCount

Methods:

refreshCount()

# AdController

Reactive Variables:

canShowInterstitial

nativeAdsLoaded

Methods:

loadNativeAds()

showInterstitial()

# AnalyticsController

Purpose:

Optional dashboard analytics.

Methods:

trackEvent()

# Global AppController

Purpose:

App-wide state

Reactive Variables:

themeMode

appVersion

maintenanceMode

Methods:

refreshRemoteConfig()

# Data Flow Pattern

UI

→ Controller

→ Repository

→ Datasource

→ Firebase

→ Datasource

→ Repository

→ Controller

→ UI

# Controller Dependencies

HomeController

depends on:

CaseRepository

VoteRepository

AnalyticsService

# CreateCaseController

depends on:

CaseRepository

AnalyticsService

# ProfileController

depends on:

UserRepository

PremiumService

# PremiumController

depends on:

PremiumRepository

RevenueCatService

# Smart Refresh Rules

Feed:

Pull to refresh

Profile:

Refresh on open

Notifications:

Refresh on open

# Error Handling

Reactive Variable:

errorMessage

States:

null

error text

# Loading Handling

Reactive Variable:

isLoading

Every screen must support:

Loading

Success

Empty

Error

# Permanent Controllers

AppController

AuthController

NotificationBadgeController

# Disposable Controllers

HomeController

CreateCaseController

ProfileController

PremiumController

SettingsController

# Controller Naming Rules

home_controller.dart

create_case_controller.dart

profile_controller.dart

# Testing Requirements

Each controller must include:

Unit tests

State tests

Error tests

# MVP Controllers

AuthController

OnboardingController

HomeController

CreateCaseController

NotificationsController

ProfileController

PremiumController

SettingsController

ReportController

AppController

NotificationBadgeController
