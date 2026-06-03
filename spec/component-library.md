# component-library.md
## Verdict – Relationship Jury
### Design System & Reusable Components Specification v1.0

# Design Philosophy

Components must be:

- Reusable
- Stateless when possible
- Theme driven
- Responsive
- Accessible

# Color Tokens

Primary:
#5E2EF5

Success:
#00C853

Warning:
#FFB300

Error:
#D50000

Surface:
#FFFFFF

Surface Dark:
#121212

# Typography Tokens

DisplayLarge
DisplayMedium
HeadlineLarge
HeadlineMedium
TitleLarge
TitleMedium
BodyLarge
BodyMedium
BodySmall
LabelSmall

# Spacing Tokens

xxs = 4
xs = 8
sm = 12
md = 16
lg = 24
xl = 32
xxl = 48

# Radius Tokens

small = 8
medium = 12
large = 16
sheet = 24

# Elevation Tokens

level1
level2
level3

# Buttons

## PrimaryButton

Usage:

Main CTA

States:

enabled
disabled
loading

Height:

56

Radius:

14

# SecondaryButton

Outlined style.

States:

enabled
disabled
loading

# TextButton

Minimal action.

Examples:

Cancel

Skip

Learn More

# IconButton

Size:

48x48

Examples:

Back

Close

Settings

# Inputs

## AppTextField

Variants:

default
error
disabled

Features:

counter
helper text
validation

# AppMultilineField

Used:

Case description

Min Lines:
4

Max Lines:
8

# Cards

## AppCard

Base card used everywhere.

Padding:

16

Radius:

16

# FeedCard

Displays:

Relationship Type

Description

Question

Vote Area

Results

Actions

# StatsCard

Used:

Profile statistics

Examples:

Cases Posted

Votes Received

# PremiumCard

Displays:

Subscription plan

Price

Benefits

# Chips

## CategoryChip

Selected:

Primary background

Unselected:

Surface background

# FilterChip

Used:

Feed filtering

# RelationshipChip

Used:

Case creation flow

# Progress Components

## LinearProgress

Used:

Create flow

Premium loading

# CircularLoader

Used:

Button loading

Small async actions

# Empty States

## EmptyFeedState

Illustration

Title

Subtitle

Action

# EmptyNotificationsState

Illustration

Message

# EmptySavedCasesState

Illustration

Message

# Error States

## GenericErrorState

Title

Description

Retry Button

# NetworkErrorState

Specific network messaging

# Vote Components

## VoteButtons

Options:

You're Right

They're Right

Both Wrong

Need More Info

Animation:

Selection pulse

# VoteResultBars

Displays:

Percentage bars

Vote counts

Winner highlight

# Feed Components

## FeedHeader

Logo

Notification icon

# SaveButton

States:

saved

unsaved

Animation:

Scale

# ShareButton

Opens share sheet.

# Notification Components

## NotificationTile

Title

Body

Time

Unread indicator

# NotificationBadge

Displays count.

# Profile Components

## ProfileHeader

Avatar

Display Name

Premium Badge

# StatisticsGrid

2x2 grid.

# PremiumBanner

Upgrade CTA.

# Premium Components

## PricingCard

Plan

Price

Features

Selected State

# BenefitTile

Icon

Title

Description

# Bottom Sheets

## ReportBottomSheet

Reasons list

Submit button

# ConfirmationBottomSheet

Title

Description

Confirm

Cancel

# Dialogs

## DeleteAccountDialog

Requires:

Type DELETE

# SuccessDialog

Animated success state

# Navigation Components

## BottomNavigationBar

Tabs:

Home

Create

Inbox

Profile

# NavigationBadge

Unread count

# Skeletons

## FeedCardSkeleton

Used during loading.

# NotificationSkeleton

Used during inbox loading.

# Animations

## Vote Success

Duration:

300ms

Sequence:

Pulse

Fade

Expand

# Card Expand

Duration:

200ms

Used:

Show More

# Tab Transition

Duration:

200ms

# Bottom Sheet

Duration:

300ms

Slide Up

# Accessibility

Minimum Touch Target:

48x48

Supports:

Dynamic Text

Screen Readers

High Contrast

# Dark Mode Support

Every component must support:

light

dark

# Naming Convention

AppButton

AppTextField

AppCard

FeedCard

VoteButtons

ResultsBars

PremiumBanner

NotificationTile

# MVP Components

PrimaryButton

SecondaryButton

TextButton

AppTextField

AppMultilineField

AppCard

FeedCard

VoteButtons

VoteResultBars

SaveButton

ShareButton

NotificationTile

ProfileHeader

StatisticsGrid

PremiumBanner

PricingCard

ReportBottomSheet

FeedCardSkeleton

ErrorState
