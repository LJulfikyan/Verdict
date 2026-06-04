# Debug Logging Report

## Files Inspected

### Core services and routing

- `lib/core/services/app_initializer.dart`
- `lib/core/services/auth_service.dart`
- `lib/core/services/notification_service.dart`
- `lib/core/services/premium_service.dart`
- `lib/core/services/ad_service.dart`
- `lib/core/services/remote_config_service.dart`
- `lib/core/routes/auth_guard.dart`

### Data sources and repositories

- `lib/data/datasources/firebase_auth_datasource.dart`
- `lib/data/datasources/firestore_datasource.dart`
- `lib/data/datasources/functions_datasource.dart`
- `lib/data/datasources/notification_datasource.dart`
- `lib/data/repositories/auth_repository.dart`
- `lib/data/repositories/case_repository.dart`
- `lib/data/repositories/user_repository.dart`
- `lib/data/repositories/vote_repository.dart`
- `lib/data/repositories/report_repository.dart`
- `lib/data/repositories/notification_repository.dart`
- `lib/data/repositories/premium_repository.dart`

### Controllers and UI catch points

- `lib/features/auth/controllers/auth_controller.dart`
- `lib/features/auth/pages/login_page.dart`
- `lib/features/create_case/controllers/create_case_controller.dart`
- `lib/features/create_case/pages/question_step_page.dart`
- `lib/features/home/controllers/home_controller.dart`
- `lib/features/home/controllers/case_detail_controller.dart`
- `lib/features/profile/controllers/profile_controller.dart`
- `lib/features/profile/controllers/edit_profile_controller.dart`
- `lib/features/premium/controllers/premium_controller.dart`
- `lib/features/settings/controllers/settings_controller.dart`

## Files Modified

- `lib/core/services/debug_logger.dart`
- `lib/core/services/app_initializer.dart`
- `lib/core/services/auth_service.dart`
- `lib/core/services/notification_service.dart`
- `lib/core/services/premium_service.dart`
- `lib/core/services/ad_service.dart`
- `lib/core/services/remote_config_service.dart`
- `lib/core/routes/auth_guard.dart`
- `lib/data/datasources/firebase_auth_datasource.dart`
- `lib/data/datasources/firestore_datasource.dart`
- `lib/data/datasources/functions_datasource.dart`
- `lib/data/repositories/auth_repository.dart`
- `lib/data/repositories/case_repository.dart`
- `lib/data/repositories/user_repository.dart`
- `lib/data/repositories/vote_repository.dart`
- `lib/data/repositories/report_repository.dart`
- `lib/data/repositories/notification_repository.dart`
- `lib/data/repositories/premium_repository.dart`
- `lib/features/auth/controllers/auth_controller.dart`
- `lib/features/auth/pages/login_page.dart`
- `lib/features/create_case/controllers/create_case_controller.dart`
- `lib/features/create_case/pages/question_step_page.dart`
- `lib/features/home/controllers/home_controller.dart`
- `lib/features/home/controllers/case_detail_controller.dart`
- `lib/features/profile/controllers/profile_controller.dart`
- `lib/features/profile/controllers/edit_profile_controller.dart`
- `lib/features/premium/controllers/premium_controller.dart`
- `lib/features/settings/controllers/settings_controller.dart`

## Catch Blocks Found

- Total `try/catch` / typed catch locations found in `lib/`: `42`

### Catch locations audited for lost information

- Authentication
  - `lib/features/auth/controllers/auth_controller.dart:55`
  - `lib/features/auth/pages/login_page.dart:47`
  - `lib/data/repositories/auth_repository.dart:72`
  - `lib/data/repositories/auth_repository.dart:88`
  - `lib/data/datasources/firebase_auth_datasource.dart:47`
- Create Case
  - `lib/features/create_case/controllers/create_case_controller.dart:129`
  - `lib/features/create_case/pages/question_step_page.dart:51`
- Feed / Case Detail
  - `lib/features/home/controllers/home_controller.dart:79`
  - `lib/features/home/controllers/home_controller.dart:152`
  - `lib/features/home/controllers/home_controller.dart:163`
  - `lib/features/home/controllers/home_controller.dart:192`
  - `lib/features/home/controllers/case_detail_controller.dart:86`
  - `lib/features/home/controllers/case_detail_controller.dart:120`
  - `lib/features/home/controllers/case_detail_controller.dart:130`
  - `lib/features/home/controllers/case_detail_controller.dart:158`
- Profile
  - `lib/features/profile/controllers/profile_controller.dart:120`
  - `lib/features/profile/controllers/profile_controller.dart:147`
  - `lib/features/profile/controllers/edit_profile_controller.dart:71`
  - `lib/features/profile/controllers/edit_profile_controller.dart:108`
- Premium / RevenueCat
  - `lib/features/premium/controllers/premium_controller.dart:63`
  - `lib/features/premium/controllers/premium_controller.dart:86`
  - `lib/data/repositories/premium_repository.dart:9`
  - `lib/data/repositories/premium_repository.dart:24`
  - `lib/data/repositories/premium_repository.dart:52`
  - `lib/data/repositories/premium_repository.dart:68`
- Notifications
  - `lib/core/services/notification_service.dart:158`
  - `lib/core/services/notification_service.dart:187`
  - `lib/data/repositories/notification_repository.dart:41`
  - `lib/data/repositories/notification_repository.dart:66`
  - `lib/data/repositories/notification_repository.dart:89`
- Settings
  - `lib/features/settings/controllers/settings_controller.dart:41`
- Repository / data failures
  - `lib/data/repositories/case_repository.dart:45`
  - `lib/data/repositories/case_repository.dart:77`
  - `lib/data/repositories/case_repository.dart:111`
  - `lib/data/repositories/case_repository.dart:132`
  - `lib/data/repositories/user_repository.dart:32`
  - `lib/data/repositories/user_repository.dart:71`
  - `lib/data/repositories/user_repository.dart:94`
  - `lib/data/repositories/vote_repository.dart:28`
  - `lib/data/repositories/report_repository.dart:26`
  - `lib/data/datasources/functions_datasource.dart:31`

## Locations Where Information Was Previously Lost

### Swallowed or flattened exceptions

- Generic `catch (_)`, `catch (error)` without stack traces in controllers:
  - feed loading
  - case detail loading
  - create-case submission
  - login flow
  - profile load/save
  - premium restore/purchase
  - settings metadata load

### User-facing message replacement without preserved raw details

- `HomeController.vote()` replaced real failures with:
  - `Could not submit your vote right now.`
- `CaseDetailController.toggleSave()` replaced real failures with:
  - `Could not update saved state right now.`
- `CreateCaseController.submitCase()` replaced raw function errors with:
  - `Could not submit your case right now.`
- `AuthController._run()` mapped raw auth exceptions to friendly sign-in messages
- `PremiumController` collapsed RevenueCat failures into:
  - `Purchase failed. Please try again.`
  - `Restore failed. Please try again.`
- `NotificationService` printed partial token errors with `debugPrint`, without structured module/class/method formatting

### Repository and data-source blind spots

- Cloud Function calls in `FunctionsDataSource` had no structured call/failure logging
- Firestore query methods had no query diagnostics
- Missing document cases in repositories were returned as `null` with no debug trace
- RevenueCat repository failures had no structured diagnostics

## Logging Added

### Global logger

- Added `lib/core/services/debug_logger.dart`
- Logging is guarded by `kDebugMode`
- Standard format:
  - `[MODULE]`
  - `Class:`
  - `Method:`
  - `Error Type:`
  - `Message:`
  - `Additional Details:`
  - `Stack Trace:`

### Special exception detail extraction

- `FirebaseAuthException`
  - `code`
  - `email`
  - `credential`
- `FirebaseFunctionsException`
  - `code`
  - `message`
  - `details`
- `FirebaseException`
  - `plugin`
  - `code`
  - `message`
- `RevenueCat` / `PlatformException`
  - `platform.code`
  - `platform.message`
  - `platform.details`
  - `revenueCat.code`
- `Dio`-style dynamic extraction helper
  - request URL
  - method
  - status code
  - response body

### Startup diagnostics

- Firebase initialized
- Firestore persistence enabled
- Functions region initialized
- RevenueCat initialization state
- AdMob initialization state
- FCM token state
- current user state
- environment key presence flags
- remote config defaults/active values

### Repository diagnostics

- Firestore query logging in `FirestoreDataSource`
- Cloud Function call logging in `FunctionsDataSource`
- repository error logging for:
  - cases
  - users
  - votes
  - reports
  - notifications
  - RevenueCat
- missing document logging for user/case lookups

### Controller diagnostics

- auth state transitions
- create-case step transitions
- feed loading failures
- vote/save action failures
- case-detail failures
- profile refresh and saved-case failures
- edit-profile load/save failures
- premium restore/purchase failures
- settings metadata failures

### Router diagnostics

- login success navigation
- create-case success navigation
- auth-guard redirects
- notification deep-link navigation

## Potential Bugs Discovered During Audit

### Fixed during this pass

- `NotificationService._navigateToRoute()` could dereference `Get.context` before null-checking during logging. This was corrected while adding router diagnostics.

### Still present / notable

- `SettingsController` notification toggles are local-only and not persisted.
- `NotificationRepository.deleteNotification()` still writes directly through Firestore instead of Cloud Functions.
- Several user-facing flows still intentionally replace raw errors with friendly messages in UI, but raw details are now logged in debug mode.
- `firebase.json` still contains a nonstandard `flutter` key that Firebase CLI warns about. Not part of this pass, but operationally relevant.

## Notes

- No production logging behavior was added.
- No business logic, routing behavior, Firestore schema, or UI messaging semantics were intentionally changed.
