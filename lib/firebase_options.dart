// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC4-L69MQyqovAlwXhK4Jgq2jGVWCnL_bI',
    appId: '1:534631611099:web:2553b55bc22a8375b8aafe',
    messagingSenderId: '534631611099',
    projectId: 'blackoffer-30666',
    authDomain: 'blackoffer-30666.firebaseapp.com',
    storageBucket: 'blackoffer-30666.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC_JSToz4C51VqWQPAnPiQRyOr142gsyg',
    appId: '1:534631611099:android:d30d5746cae7e2d6b8aafe',
    messagingSenderId: '534631611099',
    projectId: 'blackoffer-30666',
    storageBucket: 'blackoffer-30666.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjQKIOrawqg0NO42eerWOKf_ICj9zKjTE',
    appId: '1:534631611099:ios:7e06cbe3b17e762db8aafe',
    messagingSenderId: '534631611099',
    projectId: 'blackoffer-30666',
    storageBucket: 'blackoffer-30666.appspot.com',
    iosBundleId: 'com.example.blackoffer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjQKIOrawqg0NO42eerWOKf_ICj9zKjTE',
    appId: '1:534631611099:ios:0f45c865bb44e284b8aafe',
    messagingSenderId: '534631611099',
    projectId: 'blackoffer-30666',
    storageBucket: 'blackoffer-30666.appspot.com',
    iosBundleId: 'com.example.blackoffer.RunnerTests',
  );
}
