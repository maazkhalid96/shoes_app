import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
     dataauth() {}
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

      firestore.collection("users").doc(res.user?.uid).set({
        "email": email,
        "phone": phone,
        "username": username,
        "profileImagePath" : imagePath ?? "",
        "role" :  "user",
        "createdAt": DateTime.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Account Created Successfully!")));
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      userNameController.clear();
      Navigator.pop(context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
