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
    apiKey: 'AIzaSyBIzB2qACkbCWmgwDTCDJK2LPFgkRKELM4',
    appId: '1:613818484293:web:9a490b099f8ef0d475452c',
    messagingSenderId: '613818484293',
    projectId: 'venue-449ac',
    authDomain: 'venue-449ac.firebaseapp.com',
    storageBucket: 'venue-449ac.appspot.com',
    measurementId: 'G-WFF6KB78MF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBi2OTEOFNRAFt7H8X7hH8FmJcq-L-wTXM',
    appId: '1:613818484293:android:1b56da408e9660e375452c',
    messagingSenderId: '613818484293',
    projectId: 'venue-449ac',
    storageBucket: 'venue-449ac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNegWiQl_7bVT-XBykpPxIc5VAA854tEw',
    appId: '1:613818484293:ios:0b4775fcb4bb2f4575452c',
    messagingSenderId: '613818484293',
    projectId: 'venue-449ac',
    storageBucket: 'venue-449ac.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNegWiQl_7bVT-XBykpPxIc5VAA854tEw',
    appId: '1:613818484293:ios:0b4775fcb4bb2f4575452c',
    messagingSenderId: '613818484293',
    projectId: 'venue-449ac',
    storageBucket: 'venue-449ac.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBIzB2qACkbCWmgwDTCDJK2LPFgkRKELM4',
    appId: '1:613818484293:web:143dcfb844aafeeb75452c',
    messagingSenderId: '613818484293',
    projectId: 'venue-449ac',
    authDomain: 'venue-449ac.firebaseapp.com',
    storageBucket: 'venue-449ac.appspot.com',
    measurementId: 'G-5NR2N0PVZV',
  );
}
