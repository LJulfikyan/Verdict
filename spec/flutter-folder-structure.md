# flutter-folder-structure.md
## Verdict – Relationship Jury
### Flutter Project Structure Specification v1.0

# Architecture Style

Feature First Architecture

Principles:

- Separation of concerns
- Testability
- Scalability
- GetX based
- Repository pattern
- AI-codegen friendly

# Root Structure

lib/

core/
data/
features/
main.dart

# Core Layer

core/

constants/
theme/
routes/
services/
widgets/
utils/
extensions/
mixins/

# constants/

app_constants.dart

api_constants.dart

remote_config_keys.dart

analytics_events.dart

# theme/

app_theme.dart

colors.dart

text_theme.dart

dimensions.dart

# routes/

app_router.dart

route_names.dart

auth_guard.dart

# services/

auth_service.dart

analytics_service.dart

notification_service.dart

ad_service.dart

premium_service.dart

share_service.dart

# widgets/

app_button.dart

app_text_field.dart

app_card.dart

loading_skeleton.dart

empty_state.dart

error_state.dart

# utils/

validators.dart

date_utils.dart

number_utils.dart

debouncer.dart

# Data Layer

data/

models/
repositories/
datasources/

# models/

user_model.dart

case_model.dart

vote_model.dart

report_model.dart

notification_model.dart

subscription_model.dart

boost_model.dart

# repositories/

auth_repository.dart

case_repository.dart

vote_repository.dart

report_repository.dart

notification_repository.dart

premium_repository.dart

# datasources/

firebase_auth_datasource.dart

firestore_datasource.dart

functions_datasource.dart

# Features

features/

auth/
onboarding/
home/
create_case/
notifications/
profile/
premium/
settings/
moderation/

# Feature Structure

feature/

bindings/
controllers/
pages/
widgets/
models/

# Example

home/

bindings/
controllers/
pages/
widgets/

# bindings/

home_binding.dart

# controllers/

home_controller.dart

# pages/

home_page.dart

# widgets/

feed_card.dart

vote_buttons.dart

results_view.dart

feed_loading.dart

# Auth Feature

auth/

pages:

login_page.dart

Controllers:

auth_controller.dart

# Onboarding Feature

pages:

splash_page.dart

onboarding_page.dart

# Home Feature

pages:

home_page.dart

widgets:

feed_card.dart

vote_buttons.dart

results_bars.dart

share_case_button.dart

save_case_button.dart

# Create Case Feature

pages:

relationship_step_page.dart

category_step_page.dart

description_step_page.dart

question_step_page.dart

success_page.dart

controllers:

create_case_controller.dart

# Notifications Feature

pages:

notifications_page.dart

controllers:

notifications_controller.dart

widgets:

notification_tile.dart

# Profile Feature

pages:

profile_page.dart

controllers:

profile_controller.dart

widgets:

profile_stats.dart

premium_banner.dart

# Premium Feature

pages:

premium_page.dart

controllers:

premium_controller.dart

widgets:

pricing_card.dart

benefits_list.dart

# Settings Feature

pages:

settings_page.dart

controllers:

settings_controller.dart

# Moderation Feature

pages:

report_sheet.dart

widgets:

report_reason_tile.dart

# Dependency Injection

Global Services:

Get.put(AuthService())

Get.put(AnalyticsService())

Get.put(NotificationService())

Get.put(AdService())

Get.put(PremiumService())

# Navigation

GoRouter

Routes:

/

/onboarding

/login

/home

/create

/inbox

/profile

/premium

/settings

# State Management

GetX Only

Rule:

No business logic in UI.

UI

→ Controller

→ Repository

→ Datasource

→ Firebase

# Naming Convention

Pages:

home_page.dart

Controllers:

home_controller.dart

Repositories:

case_repository.dart

Models:

case_model.dart

# Loading States

Every feature must include:

loading

empty

error

success

# Asset Structure

assets/

images/
icons/
animations/

# Images

logo.png

empty_feed.png

premium_banner.png

# Icons

home.svg

create.svg

inbox.svg

profile.svg

# Animations

success.json

loading.json

# Localization

l10n/

en.json

future:

es.json

fr.json

de.json

# Environment Files

.env.dev

.env.staging

.env.prod

# Testing Structure

test/

unit/
widget/
integration/

# Unit

repositories

controllers

services

# Widget

feed_card_test.dart

vote_buttons_test.dart

profile_page_test.dart

# Integration

auth_flow_test.dart

vote_flow_test.dart

create_case_flow_test.dart

# Build Flavors

dev

staging

prod

# Release Structure

Separate Firebase project per flavor.

# Definition of Done

Every feature includes:

Page

Controller

Binding

Repository

Loading State

Error State

Analytics

Tests

# MVP Folder Checklist

Core

Data

Auth

Onboarding

Home

Create Case

Notifications

Profile

Premium

Settings

Moderation

Tests
