# go-router-map.md
## Verdict – Relationship Jury
### Navigation, Deep Links & Route Architecture v1.0

# Navigation Goals

- Predictable navigation
- Deep link support
- Authentication guards
- Simple URL structure
- AI-codegen friendly

# Router Technology

GoRouter

Navigation Pattern:

Bottom Navigation + Nested Routes

# Route Naming Rules

Name == Path

Example:

name: "/home"
path: "/home"

# Root Flow

/

↓

splash

↓

onboarding

↓

login

↓

home

# Public Routes

/

/splash

/onboarding

/login

# Protected Routes

/home

/create

/inbox

/profile

/premium

/settings

# Bottom Navigation

Tabs:

Home

Create

Inbox

Profile

# Route Map

/

/splash

/onboarding

/login

/home

/home/case/:caseId

/create

/create/relationship

/create/category

/create/description

/create/question

/create/success

/inbox

/profile

/profile/edit

/profile/saved

/settings

/premium

# Splash Route

Path:

/splash

Purpose:

App initialization

Checks:

Auth state

Onboarding status

# Onboarding Route

Path:

/onboarding

Displays:

3 onboarding screens

Continue button

# Login Route

Path:

/login

Options:

Google

Apple

Guest

# Home Route

Path:

/home

Contains:

Feed

Vote cards

Results

# Case Detail Route

Path:

/home/case/:caseId

Parameters:

caseId

Purpose:

Open shared case

Open notification target

# Create Flow Routes

# Relationship Step

/create/relationship

# Category Step

/create/category

# Description Step

/create/description

# Question Step

/create/question

# Success Step

/create/success

# Inbox Route

Path:

/inbox

Displays:

Notifications

# Profile Route

Path:

/profile

Displays:

User profile

Statistics

Premium banner

# Saved Cases Route

/profile/saved

Displays:

Saved cases

# Edit Profile Route

/profile/edit

Fields:

Display Name

Country

Gender

Age Range

# Settings Route

/settings

Sections:

Account

Notifications

Privacy

Legal

# Premium Route

/premium

Displays:

Subscription plans

Benefits

Purchase CTA

# Auth Guards

Guard:

AuthenticatedUserGuard

Protects:

/create

/inbox

/profile

/settings

/premium

# Guest Flow

Guest can:

Browse feed

View cases

View results

Guest cannot:

Vote

Create

Save

Report

Purchase

# Guest Redirect

Attempt protected route

↓

Open Login Screen

# Deep Linking

Supported:

verdict://case/:caseId

verdict://premium

verdict://profile

# Notification Deep Links

Case Milestone:

Open Case

Trending:

Open Case

Premium Offer:

Open Premium Screen

# Share Links

Format:

https://verdict.app/case/{caseId}

Behavior:

App Installed:

Open app

App Missing:

Open store

# Route Transitions

Default:

Fade

Duration:

250ms

# Bottom Sheet Routes

Presented:

Report

Confirmation

Delete Account

Transition:

Slide Up

Duration:

300ms

# Custom Transition Pages

Transparent Routes:

Dialogs

Bottom Sheets

# Back Navigation Rules

Create Flow:

Previous Step

Profile:

Back to Home

Premium:

Back to Previous Screen

# Tab Persistence

Bottom Tabs maintain state.

Example:

User scrolls feed

Switches tab

Returns

Position preserved

# Route Analytics

Track:

screen_view

Parameters:

route_name

user_id

# Route Error Handling

Unknown Route:

404 Screen

Message:

Page not found

Button:

Go Home

# Initial Route Logic

If first launch:

Onboarding

Else:

Splash

Auth check

Home

# Router Structure Example

ShellRoute

├── Home
├── Create
├── Inbox
└── Profile

# Future Routes

/admin

/moderation

/themes

/surveys

/referrals

Not MVP.

# MVP Route Checklist

Splash

Onboarding

Login

Home

Case Detail

Create Flow

Inbox

Profile

Saved Cases

Edit Profile

Settings

Premium

Authentication Guards

Deep Links
