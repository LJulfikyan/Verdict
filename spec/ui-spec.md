# ui-spec.md
## Verdict – Relationship Jury
### UI/UX Specification v1.0

# Design Principles

- Fast consumption
- One-handed usage
- Maximum 3 taps to any action
- No clutter
- Mobile-first
- Social-first

# Design System

Font:
Poppins

Corner Radius:
- Cards: 16
- Inputs: 12
- Buttons: 14
- Bottom Sheets: 24

Spacing Scale:
4
8
12
16
24
32
48
64

# Colors

Primary:
#5E2EF5

Success:
#00C853

Warning:
#FFB300

Error:
#D50000

Background:
#FFFFFF

Dark Background:
#121212

# Splash Screen

Background:
White

Center:
Verdict Logo

Animation:
Scale 0.8 → 1.0

Duration:
500ms

Fade In:
300ms

No spinner.

# Onboarding

Screen 1

Illustration:
Voting cards

Title:
The Internet Decides

Subtitle:
Post relationship situations and get a verdict.

Primary Button:
Next

---

Screen 2

Illustration:
Anonymous profile

Title:
Stay Anonymous

Subtitle:
No names. No photos. No drama.

Primary Button:
Next

---

Screen 3

Illustration:
Statistics chart

Title:
Vote First

Subtitle:
Results unlock only after voting.

Primary Button:
Continue

---

Screen 4

Authentication

Buttons:
Continue with Apple
Continue with Google
Continue as Guest

Button Height:
56

# Main Navigation

Bottom Navigation

Tabs:

Home
Create
Inbox
Profile

Height:
72

Selected Animation:
Scale 1.0 → 1.1

Duration:
200ms

# Home Screen

AppBar

Left:
Verdict Logo

Right:
Notification Bell

Center:
None

Height:
56

# Feed

Vertical scrolling.

Infinite pagination.

Cards occupy:
~85% width

Card Padding:
16

Card Margin:
16 horizontal
8 vertical

# Feed Card Structure

Header

Conflict

Question

Voting Section

Results Section

Footer

# Card Header

Left:

Relationship Type

Examples:
Wife
Girlfriend
Partner

Right:

Time Ago

Examples:
5m
2h
1d

# Conflict Text

Default:
150 characters visible

Show More expands.

Expand Animation:
200ms

# Question

Bold

Example:

Was I wrong?

# Vote Buttons

Before Voting

Options:

You're Right
They're Right
Both Wrong
Need More Info

Button Height:
52

Spacing:
8

Animation:

Tap

↓

Selected button pulse

↓

Other buttons fade

↓

Results appear

Duration:
300ms

# Results View

Horizontal bars

Display:

Vote Percentages

Example:

72%
15%
8%
5%

Show:

Total Votes

Example:

12,481 votes

Show:

Save button

Show:

Share button

# Share Result Screen

Generated image

Contains:

Verdict Logo

Question

Winning Option

Vote Percentages

# Feed Loading

Skeleton cards

No loading spinner

# Empty Feed

Illustration:
Empty jury box

Text:
No cases available

Button:
Refresh

# Create Flow

4 Step Process

Progress Bar Top

# Step 1

Relationship Type

Grid:

2 columns

Options:

Wife
Girlfriend
Fiancée
Boyfriend
Husband
Partner

Card Height:
80

Selected State:

Primary Border

Scale Animation:
1 → 1.05

# Step 2

Category

Chips Layout

Options:

Money
Jealousy
Family
Friends
Travel
Children
Social Media
Communication
Household

# Step 3

Conflict Description

Input

Min:
50 chars

Max:
500 chars

Live Counter

500/500

# Step 4

Question

Input

Max:
100 chars

Placeholder:

Was I wrong?

# Submission Success

Animation:

Checkmark

Scale

Duration:
600ms

Message:

Case Submitted

# Inbox Screen

Sections:

Unread
Read

Notification Card

Icon

Title

Description

Time

Tap Action

Open related case

# Profile Screen

Top Section

Avatar

Display Name

Statistics

# Statistics Cards

Cases Posted

Votes Received

Average Agreement

Cases Saved

Grid:
2x2

# Premium Banner

Visible for free users

Gradient background

CTA:

Upgrade

# Premium Screen

Header:

Unlock Verdict Plus

Pricing Card

Monthly

Yearly

Benefits:

No Ads

Advanced Statistics

Demographics

Themes

Priority Support

Purchase Button

Height:
56

# Settings Screen

Sections:

Account

Notifications

Appearance

Privacy

Legal

Danger Zone

# Delete Account

Red Button

Confirmation Bottom Sheet

Requires:

Type DELETE

# Report Flow

Bottom Sheet

Reasons:

Spam

Fake Story

Personal Information

Harassment

Other

Submit Button

# Dark Mode

Supported

All screens

Pure dark background

# Animations

Screen Transition:
250ms Fade

Bottom Sheet:
300ms Slide Up

Vote:
300ms Pulse

Progress Bar:
250ms

Tab Change:
200ms

Card Expansion:
200ms

# Accessibility

Minimum Tap Target:
48x48

Dynamic Font Support

Screen Reader Labels

# Tablet Support

Centered Content

Max Width:
700

# MVP Screens

Splash

Onboarding 1

Onboarding 2

Onboarding 3

Login

Home

Create Step 1

Create Step 2

Create Step 3

Create Step 4

Inbox

Profile

Premium

Settings

Report Bottom Sheet
