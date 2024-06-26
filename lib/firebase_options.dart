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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAQ9eXKqM-wEvtA6m19QB7KaZ-WvRi9Lyg',
    appId: '1:838298723788:web:cad677883c8e5d88cb2969',
    messagingSenderId: '838298723788',
    projectId: 'devguardai-5ace7',
    authDomain: 'devguardai-5ace7.firebaseapp.com',
    storageBucket: 'devguardai-5ace7.appspot.com',
    measurementId: 'G-0Q2QL4E9KQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAJ3-sbeYQ8cIyDQs-kUYvM0YrKTybXm0',
    appId: '1:838298723788:android:8878210428fc0a4acb2969',
    messagingSenderId: '838298723788',
    projectId: 'devguardai-5ace7',
    storageBucket: 'devguardai-5ace7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPZWp-K34VtpVdsxK9l3oFFTyqvR4k49s',
    appId: '1:838298723788:ios:3b9718b8693e5491cb2969',
    messagingSenderId: '838298723788',
    projectId: 'devguardai-5ace7',
    storageBucket: 'devguardai-5ace7.appspot.com',
    iosBundleId: 'com.example.dtdl',
  );
}
