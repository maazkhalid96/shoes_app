import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';

class ProductDetail extends StatelessWidget {
  final Map product;

  ProductDetail({super.key, required this.product});

  User? user = FirebaseAuth.instance.currentUser;

  carts(BuildContext context) async {
    try {
      
      await FirebaseFirestore.instance
          .collection("carts")
          .doc(user?.uid)
          .collection("items")
          .add({
            "name": product["name"],
            "price": product["price"],
            "desc": product["description"],
            "image": product['image'],
            "quantity" :1 ,
            "totalPrice" : int.parse(product["price"].toString())
          });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("added to carts Successfully")));
    } catch (e) {
      print(e);
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
        backgroundColor: Colors.blueAccent,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          product["image"] != null
              ? Image.file(
                  File(product["image"]),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.image, size: 60),
          SizedBox(height: 25),

          //  Product Name
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["name"],
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                //  Price
                Text(
                  "Rs.${product["price"]}",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 20),

                //  Description
                Text(
                  product["description"],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Spacer(),
          CustomButton(
            text: "Add to Cart",
            onPressed: () {
              carts(context);
            },
          ),
        ],
      ),
    );
  }
}
