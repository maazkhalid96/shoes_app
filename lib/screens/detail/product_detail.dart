import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';

class ProductDetail extends StatefulWidget {
  final Map product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final User? user = FirebaseAuth.instance.currentUser;

  /// ADD TO CART LOGIC
  Future<void> carts(BuildContext context, Map product) async {
    try {
      QuerySnapshot existingProduct = await FirebaseFirestore.instance
          .collection("carts")
          .doc(user!.uid)
          .collection("items")
          .where("name", isEqualTo: product["name"])
          .get();

      if (existingProduct.docs.isNotEmpty) {
        var doc = existingProduct.docs.first;

        int currentQty = doc["quantity"];
        int price = int.parse(product["price"].toString());

        await FirebaseFirestore.instance
            .collection("carts")
            .doc(user!.uid)
            .collection("items")
            .doc(doc.id)
            .update({
              "quantity": currentQty + 1,
              "totalPrice": price * (currentQty + 1),
            });

        showDialogMessage(context, "Product quantity updated", Colors.orange);
        return;
      }

      // 🟢 PRODUCT NOT EXISTS → ADD NEW
      await FirebaseFirestore.instance
          .collection("carts")
          .doc(user!.uid)
          .collection("items")
          .add({
            "name": product["name"],
            "price": product["price"],
            "desc": product["description"],
            "image": product["image"],
            "quantity": 1,
            "totalPrice": int.parse(product["price"].toString()),
          });

      showDialogMessage(context, "Added to cart successfully", Colors.green);
    } catch (e) {
      print("Cart Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product["name"]),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.product["image"] != null
              ? Image.file(
                  File(widget.product["image"]),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image, size: 60),

          const SizedBox(height: 25),

          /// PRODUCT DETAILS
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product["name"],
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                Text(
                  "Rs.${widget.product["price"]}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.product["description"],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              text: "Add to Cart",
              onPressed: () {
                carts(context, widget.product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// CENTER DIALOG MESSAGE (Reusable)
void showDialogMessage(BuildContext context, String message, Color color) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        Navigator.pop(context);
      });

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  color == Colors.green ? Icons.check_circle : Icons.info,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
