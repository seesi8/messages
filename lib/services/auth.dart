import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messages/services/firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException {
      // handle error
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithPassword(
      {final String emailAddress = '', final String password = ''}) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  Future<bool> createAccountWithUsernameAndPassword(
      {required final BuildContext context,
      String email = '',
      String password = '',
      String displayName = '',
      XFile? file}) async {
    if (file == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: const Text("You are Missing Your Profile Image"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );
      return false;
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        print("now");
        await FirestoreService().createUser(
            userCredential: userCredential,
            displayName: displayName,
            file: file);
        return true;
      });
    } on FirebaseAuthException catch (error) {
      String errorCode = error.code;
      String? errorMessage = error.message;
      print("hi $errorCode");
      if (errorCode.contains("email")) {
        print("yup");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Email May Be In Use Or invalid"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
        return false;
      } else if (errorCode.contains("password")) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Invalid Password"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
        return false;
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Invalid Info"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
        return false;
      }
    }
    return true;
  }
}
