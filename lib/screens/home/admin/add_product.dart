import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';

import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/controller/add_product_controller.dart';
import 'package:shoes_app_ui/services/cloudinary_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final AddProductController getController = AddProductController();
  String? selectedCategory;
  bool isLoading = false;
  File? imageFilee;
  List<String> categories = ["Men Shoes", "Women Shoes", "Kids Shoes"];

  // Pick image from gallery
  pickImage() async {
    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (pick == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No image selected")));
    } else {
      setState(() {
        imageFilee = File(pick.path);
      });
    }
  }

  // Add product to Firestore
  addProduct() async {
    // Check all fields including image
    if (getController.productName.text.isEmpty ||
        getController.price.text.isEmpty ||
        getController.category.text.isEmpty ||
        getController.description.text.isEmpty ||
        imageFilee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required including image!")),
      );
      return; // Stop execution
    }

    setState(() {
      isLoading = true;
    });
    String? imageUrl;

    try {
      imageUrl = await CloudinaryService.uploadImage(imageFilee!);
      if (imageUrl == null) {
        setState(() => isLoading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
        return;
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }

    try {
      await FirebaseFirestore.instance.collection("products").add({
        "name": getController.productName.text,
        "price": int.parse(getController.price.text),
        "category": getController.category.text,
        "description": getController.description.text,
        "image": imageUrl,
        "createdAt": DateTime.now(),
      });
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product added successfully!")));

      // Clear fields
      getController.productName.clear();
      getController.price.clear();
      getController.category.clear();
      getController.description.clear();
      setState(() {
        imageFilee = null;
        selectedCategory = null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              hintText: "Product Name",
              controller: getController.productName,
            ),
            SizedBox(height: 12),
            CustomInputField(
              hintText: "Price",
              textInputType: TextInputType.number,

              controller: getController.price,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),

                hintText: "Select Category",
              ),
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  getController.category.text = value!;
                });
              },
            ),

            SizedBox(height: 12),
            CustomInputField(
              hintText: "Description",
              controller: getController.description,
              maxline: 5,
            ),
            SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.amber,
                    backgroundImage: imageFilee != null
                        ? FileImage(imageFilee!)
                        : null,
                    child: imageFilee == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 15),
                CustomButton(
                  text: "Add Product",
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await addProduct();
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
