import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductFavorite {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  addFavorite(Map<String, dynamic> product, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(uid)
          .collection("items")
          .doc(product["id"].toString())
          .set(product);
      if (!context.mounted) return;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Product added to favorites!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding favorite: $e")));
    }
  }

  deleteFavorites(String productId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(uid)
          .collection("items")
          .doc(productId)
          .delete();
      if (!context.mounted) return;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Product removed from favorites")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding favorite: $e")));
    }
  }
}
