import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoes_app_ui/screens/home/admin/admin_dashboard.dart';
import 'package:shoes_app_ui/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 


class LoginAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  login({
    required String email,
    required String password,
    required TextEditingController emailController,
    required TextEditingController passwordController,

    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email or Password cannot be empty!")),
      );
      return;
    }

    try {
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // print('login dataaaaaa: ${res.user?.uid}');
      final uid = res.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final role = userDoc["role"];

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Successful!")));

      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
