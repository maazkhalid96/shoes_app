import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent! Check your inbox."),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
