# Firebase Setup

## Required Firebase Services
- Authentication
- Cloud Firestore
- Cloud Functions
- Firebase Messaging
- Firebase Analytics
- Firebase Crashlytics

## Required Authentication Providers
- Anonymous
- Google
- Apple

## Deployment Commands
- Deploy Firestore rules:
  - `firebase deploy --only firestore:rules`
- Deploy Functions:
  - `firebase deploy --only functions`

## Required Indexes
- `cases`
  - `status ASC, hotScore DESC`
- `cases`
  - `category ASC, hotScore DESC`
- `cases`
  - `relationshipType ASC, hotScore DESC`
- `users/{userId}/notifications`
  - `isRead ASC, createdAt DESC`

## Required Environment Variables
- `REVENUECAT_ANDROID_API_KEY`
- `REVENUECAT_IOS_API_KEY`
- `GOOGLE_WEB_CLIENT_ID`
- `GOOGLE_SERVER_CLIENT_ID`
- `ADMOB_ANDROID_APP_ID`
- `ADMOB_IOS_APP_ID`
- `ADMOB_ANDROID_INTERSTITIAL_ID`
- `ADMOB_IOS_INTERSTITIAL_ID`
- `ADMOB_ANDROID_NATIVE_ID`
- `ADMOB_IOS_NATIVE_ID`

## Local Development Setup
- Run `flutterfire configure` for the target Firebase project.
- Ensure these files are present and current:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- Create the `(default)` Firestore database in Native mode.
- Install Functions dependencies:
  - `cd functions && npm install`

## Production Deployment Checklist
- Firestore database exists in the correct project
- Firestore rules deployed
- Required indexes created
- Functions deployed
- Auth providers enabled
- APNs configured for iOS push notifications
- Crashlytics enabled
- Analytics enabled
- Release environment variables provided
