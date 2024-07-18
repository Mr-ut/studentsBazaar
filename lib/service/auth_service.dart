import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Google sign in
  signInWithGoogle() async {
    try {
      // Begin sign in process
      print("Starting Google Sign-In process");
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // User canceled the sign-in process
        print("Google Sign-In canceled");
        return null;
      }

      // Obtain auth details from request
      print("Google Sign-In successful, obtaining authentication");
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally sign in
      print("Signing in with Firebase");
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Firebase sign-in successful: ${userCredential.user}");
      return userCredential;
    } catch (error) {
      print("Sign-In Error: $error");
      rethrow;
    }
  }
}

class MicrosoftSignIn {
  static Future<void> signInWithMicrosoft(BuildContext context) async {
    try {
      final OAuthProvider oAuthProvider = OAuthProvider("microsoft.com");
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(oAuthProvider);

      if (userCredential.user == null) {
        // Handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: User not found")));
        return;
      }
      // print(userCredential.user.)
      // Successful sign-in
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign in successful ")));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
