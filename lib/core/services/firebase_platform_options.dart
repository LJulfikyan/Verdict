import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebasePlatformOptions {
  const FirebasePlatformOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: _env('FIREBASE_WEB_API_KEY'),
        appId: _env('FIREBASE_WEB_APP_ID'),
        messagingSenderId: _env('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _env('FIREBASE_PROJECT_ID'),
        authDomain: _env('FIREBASE_WEB_AUTH_DOMAIN'),
        storageBucket: _env('FIREBASE_STORAGE_BUCKET'),
        measurementId: _env('FIREBASE_WEB_MEASUREMENT_ID', required: false),
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: _env('FIREBASE_ANDROID_API_KEY'),
          appId: _env('FIREBASE_ANDROID_APP_ID'),
          messagingSenderId: _env('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: _env('FIREBASE_PROJECT_ID'),
          storageBucket: _env('FIREBASE_STORAGE_BUCKET'),
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: _env('FIREBASE_IOS_API_KEY'),
          appId: _env('FIREBASE_IOS_APP_ID'),
          messagingSenderId: _env('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: _env('FIREBASE_PROJECT_ID'),
          storageBucket: _env('FIREBASE_STORAGE_BUCKET'),
          iosBundleId: _env('FIREBASE_IOS_BUNDLE_ID'),
        );
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: _env('FIREBASE_MACOS_API_KEY'),
          appId: _env('FIREBASE_MACOS_APP_ID'),
          messagingSenderId: _env('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: _env('FIREBASE_PROJECT_ID'),
          storageBucket: _env('FIREBASE_STORAGE_BUCKET'),
          iosBundleId: _env('FIREBASE_MACOS_BUNDLE_ID'),
        );
      default:
        throw UnsupportedError(
          'Firebase is configured only for web, Android, iOS, and macOS in this project.',
        );
    }
  }

  static String _env(String key, {bool required = true}) {
    final value = String.fromEnvironment(key);
    if (required && value.isEmpty) {
      throw StateError(
        'Missing required Firebase define: $key. Configure your platform values before running the app.',
      );
    }
    return value;
  }
}
