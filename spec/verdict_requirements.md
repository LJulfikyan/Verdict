# Verdict – Relationship Jury
## Product Requirements Document (PRD v1.0)

# 1. Product Vision
Verdict is a social voting platform where users anonymously post relationship conflicts and receive a verdict from the community.

Core loop:
1. User posts relationship conflict
2. Community votes
3. User receives verdict
4. User shares verdict
5. New users join

# 2. Business Goal
Primary Goal:
Build a highly shareable social product capable of reaching:
- 100k users
- 500k users
- 1M users

Revenue:
- Native ads
- Premium subscription
- Case boosts

# 3. User Roles
## Regular User
- Register
- Create cases
- Vote
- Report
- Save cases
- Purchase premium
- Purchase boosts

## Moderator
- Hide case
- Delete case
- Ban user
- Restore case

## Admin
Full access

# 4. Technology Stack
Frontend:
- Flutter
- GetX
- GoRouter

Backend:
- Firebase Auth
- Firestore
- Firebase Functions
- Firebase Analytics
- Firebase Messaging
- Firebase Remote Config
- Firebase Crashlytics

Monetization:
- RevenueCat
- AdMob

# 5. Navigation
Bottom tabs:
- Home
- Create
- Inbox
- Profile

# 6. Feed
- Infinite scrolling
- Vertical cards
- Vote before results
- Results animate after vote

Vote options:
- You're Right
- They're Right
- Both Wrong
- Need More Info

# 7. Create Case
Relationship Type:
- Wife
- Girlfriend
- Fiancée
- Boyfriend
- Husband
- Partner

Categories:
- Money
- Jealousy
- Friends
- Family
- Travel
- Social Media
- Children
- Communication
- Household

# 8. Monetization
Ads:
- Native ad every 10 cards
- Interstitial every 50 votes
- Max 3/day

Premium:
- No ads
- Demographics
- Analytics
- Themes

Boost:
- $0.99
- 24h duration
- 10x visibility

# 9. Database Collections

users
cases
votes
reports

# 10. Analytics
- app_open
- case_view
- case_vote
- case_create
- premium_purchase
- boost_purchase

# 11. MVP
- Authentication
- Feed
- Voting
- Results
- Create Case
- Profile
- Reporting
- Notifications
- Ads
- Premium
