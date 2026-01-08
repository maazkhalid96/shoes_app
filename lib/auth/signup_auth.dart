import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoes_app_ui/services/cloudinary_service.dart';

class SignupAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  signUp({
    required String email,
    required String password,
    required String phone,
    required String username,
    String? imagePath,

    required BuildContext context,
    required TextEditingController userNameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    if (email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("This fields are required!")));
      return;
    }

    if (!email.endsWith("@gmail.com")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Gmail!")));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters long")),
      );
      return;
    }
    try {
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!context.mounted) return;
      String imageUrl = "";
      if (imagePath != null) {
        String? uploadedUrl = await CloudinaryService.uploadImage(
          File(imagePath),
        );
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }
      firestore.collection("users").doc(res.user?.uid).set({
        "email": email,
        "phone": phone,
        "username": username,
        "profileImagePath": imageUrl,
        "role": "user",
        "createdAt": DateTime.now(),
      });
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Account Created Successfully!")));
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      userNameController.clear();
      if (!context.mounted) return;
      Navigator.pop(context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }
}
