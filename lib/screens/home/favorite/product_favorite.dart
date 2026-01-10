import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductFavorite {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  addFavorite(Map<String, dynamic> product) async {
    try {
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(uid)
          .collection("items")
          .doc(product["id"].toString())
          .set(product);
      print("Product added to favorites!");
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }
}
