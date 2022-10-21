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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKSrUuVEFq7QYVgqeuU2z_jj5H-ySkHSk',
    appId: '1:857402905955:android:5f59543612fbc22f732f56',
    messagingSenderId: '857402905955',
    projectId: 'chat-24ce7',
    storageBucket: 'chat-24ce7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3IrGsoymHHCbHuDCwE3nj7UdzSPc9HiM',
    appId: '1:857402905955:ios:9e4f81f9a93786ee732f56',
    messagingSenderId: '857402905955',
    projectId: 'chat-24ce7',
    storageBucket: 'chat-24ce7.appspot.com',
    iosClientId: '857402905955-6706ogpntkqhr9deblo87up3vrdjnaeg.apps.googleusercontent.com',
    iosBundleId: 'dev.samueldoes.message.messages',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA3IrGsoymHHCbHuDCwE3nj7UdzSPc9HiM',
    appId: '1:857402905955:ios:9e4f81f9a93786ee732f56',
    messagingSenderId: '857402905955',
    projectId: 'chat-24ce7',
    storageBucket: 'chat-24ce7.appspot.com',
    iosClientId: '857402905955-6706ogpntkqhr9deblo87up3vrdjnaeg.apps.googleusercontent.com',
    iosBundleId: 'dev.samueldoes.message.messages',
  );
}
