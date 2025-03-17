// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBiBAD10pwrz6Lny9HNthjlJETPEIY0OVc',
    appId: '1:1076416262345:web:9456348b0a9323513d1d18',
    messagingSenderId: '1076416262345',
    projectId: 'cleanerapp-d8f4c',
    authDomain: 'cleanerapp-d8f4c.firebaseapp.com',
    storageBucket: 'cleanerapp-d8f4c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuKr1PgWiupeyUPvEMuahlnwNIAJiig9U',
    appId: '1:1076416262345:android:d992497d25aa5af63d1d18',
    messagingSenderId: '1076416262345',
    projectId: 'cleanerapp-d8f4c',
    storageBucket: 'cleanerapp-d8f4c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgV7n_dhOqC-jq8dtDwe4C_ykTQLhJ4GE',
    appId: '1:1076416262345:ios:11c84e1f30c057ca3d1d18',
    messagingSenderId: '1076416262345',
    projectId: 'cleanerapp-d8f4c',
    storageBucket: 'cleanerapp-d8f4c.firebasestorage.app',
    iosBundleId: 'com.example.cleanApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgV7n_dhOqC-jq8dtDwe4C_ykTQLhJ4GE',
    appId: '1:1076416262345:ios:11c84e1f30c057ca3d1d18',
    messagingSenderId: '1076416262345',
    projectId: 'cleanerapp-d8f4c',
    storageBucket: 'cleanerapp-d8f4c.firebasestorage.app',
    iosBundleId: 'com.example.cleanApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBiBAD10pwrz6Lny9HNthjlJETPEIY0OVc',
    appId: '1:1076416262345:web:701fb3118e47aeec3d1d18',
    messagingSenderId: '1076416262345',
    projectId: 'cleanerapp-d8f4c',
    authDomain: 'cleanerapp-d8f4c.firebaseapp.com',
    storageBucket: 'cleanerapp-d8f4c.firebasestorage.app',
  );
}
