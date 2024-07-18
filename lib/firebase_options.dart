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
    apiKey: 'AIzaSyA5eKgVpl0g9-mHT3xFcK3ysu6d4e6HW4A',
    appId: '1:444734798724:web:b7f93a5c279beb6fa97bd1',
    messagingSenderId: '444734798724',
    projectId: 'studentsbazaar-da329',
    authDomain: 'studentsbazaar-da329.firebaseapp.com',
    storageBucket: 'studentsbazaar-da329.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvSLAiMsUDiIq2l77QbNXi0MndXwJkd88',
    appId: '1:444734798724:android:a4d1dfd83a9fe0fca97bd1',
    messagingSenderId: '444734798724',
    projectId: 'studentsbazaar-da329',
    storageBucket: 'studentsbazaar-da329.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBR1nGEaq57El5uUl1-LcCuT8dRfQNSOrQ',
    appId: '1:444734798724:ios:5d94f5ed54e3f8f8a97bd1',
    messagingSenderId: '444734798724',
    projectId: 'studentsbazaar-da329',
    storageBucket: 'studentsbazaar-da329.appspot.com',
    iosBundleId: 'com.example.studentsBazaar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBR1nGEaq57El5uUl1-LcCuT8dRfQNSOrQ',
    appId: '1:444734798724:ios:5d94f5ed54e3f8f8a97bd1',
    messagingSenderId: '444734798724',
    projectId: 'studentsbazaar-da329',
    storageBucket: 'studentsbazaar-da329.appspot.com',
    iosBundleId: 'com.example.studentsBazaar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5eKgVpl0g9-mHT3xFcK3ysu6d4e6HW4A',
    appId: '1:444734798724:web:f8b7a8598b45da23a97bd1',
    messagingSenderId: '444734798724',
    projectId: 'studentsbazaar-da329',
    authDomain: 'studentsbazaar-da329.firebaseapp.com',
    storageBucket: 'studentsbazaar-da329.appspot.com',
  );
}
