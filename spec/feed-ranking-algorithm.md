# feed-ranking-algorithm.md
## Verdict – Relationship Jury
### Feed Ranking & Virality Engine Specification v1.0

# Purpose

The feed ranking system determines:

- Which cases users see
- Which cases go viral
- Which cases die
- Session length
- Retention

This is the most important growth system in the app.

# Design Goals

Promote:

- Interesting cases
- Polarizing cases
- Fast engagement
- High retention content

Avoid:

- Spam
- Old content
- Low quality content
- Repetitive content

# Feed Types

Home Feed

Trending Feed

Newest Feed

Saved Feed

Profile Feed

# Home Feed

Default feed.

Ranking Formula:

finalScore =
hotScore
+ engagementScore
+ controversyScore
+ freshnessScore
+ boostScore

# Hot Score

Measures popularity.

hotScore =

(votesCount * 4)
+ (sharesCount * 8)
+ (savesCount * 3)

# Engagement Score

Measures user interaction.

engagementScore =

(votesPerMinute * 5)
+ (viewsToVoteRatio * 50)

# View To Vote Ratio

Example:

1000 views

600 votes

Ratio:

0.6

Higher ratio = higher ranking.

# Controversy Score

Important.

Cases where people disagree are more engaging.

Formula:

100 - winnerPercentage

Examples:

90% winner

controversy = 10

55% winner

controversy = 45

# Controversy Bonus

If winner percentage:

45%-55%

Bonus:

+100

Reason:

Highly debated content.

# Freshness Score

Age Based.

0-3 Hours:
+100

3-12 Hours:
+60

12-24 Hours:
+25

1-3 Days:
+10

3+ Days:
0

# Boost Score

Purchased boosts.

Starter:
+100

Popular:
+300

Max:
+600

# Report Penalty

reportPenalty =

reportsCount * 20

Final Score:

finalScore -= reportPenalty

# Hidden Cases

Status:

hidden

Never shown.

# Deleted Cases

Status:

deleted

Never shown.

# Trending Feed

Separate ranking.

Focus:

Velocity.

Formula:

votesLastHour * 10

+ sharesLastHour * 20

+ savesLastHour * 5

# Trending Requirements

Minimum:

100 votes

Age:

<72 hours

# Newest Feed

Order:

createdAt DESC

No ranking.

# Saved Feed

User saved cases only.

Order:

savedAt DESC

# Feed Diversity Rules

Never show:

Same author twice in 10 cards.

Same category more than 3 times in 10 cards.

# Category Balancing

Target Distribution:

Money:
15%

Jealousy:
15%

Family:
15%

Friends:
10%

Travel:
10%

Children:
10%

Communication:
15%

Household:
10%

# Repeat Content Detection

Low similarity required.

If description similarity >80%:

Reduce score.

# New User Boost

First 3 cases by new user:

+50 score

Purpose:

Prevent cold start.

# Author Reputation Bonus

trustScore:

90+

Bonus:
+25

70+

Bonus:
+10

<50

Penalty:
-25

# Save Rate Bonus

saveRate =

saves / views

High save rate:

Strong signal.

Bonus:

up to +100

# Share Rate Bonus

shareRate =

shares / views

Bonus:

up to +200

# Feed Refresh Strategy

Initial Load:

20 cases

Pagination:

20 cases

Preload next page when:

70% consumed

# Personalization (Future)

Track:

Favorite categories

Vote patterns

Session history

Not MVP.

# Case Lifecycle

Created

↓

Fresh

↓

Trending

↓

Popular

↓

Archived

# Archive Logic

Case age > 90 days

Move to archived feed.

# Anti Gaming Rules

Ignore:

Self votes

Repeated devices

Suspicious voting bursts

Flag:

Moderator review

# Feed Experiments

Remote Config

Variables:

freshnessWeight

controversyWeight

shareWeight

boostWeight

# A/B Tests

Version A:

Popularity focused

Version B:

Controversy focused

Measure:

Session Length

Votes/User

Retention

# Success Metrics

Average Feed Depth:
20+ cards

Votes/User:
15+

Session Length:
8+ minutes

Share Rate:
5%+

# Recommended MVP Formula

finalScore =

(votesCount * 4)

+ (sharesCount * 8)

+ (savesCount * 3)

+ freshnessScore

+ controversyScore

+ boostScore

- reportPenalty

Simple.

Fast.

Easy to tune.

# Future Ranking Signals

User reputation

Category preferences

Country relevance

Premium promotion

Machine learning ranking

Not MVP.
