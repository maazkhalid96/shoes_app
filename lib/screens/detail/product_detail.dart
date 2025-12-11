import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';

class ProductDetail extends StatelessWidget {
  final Map product;
  const ProductDetail({super.key, required this.product});

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
          CustomButton(text: "Add to Cart", onPressed: () {
            
          }),
        ],
      ),
    );
  }
}
