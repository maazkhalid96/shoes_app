import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetProduct extends StatelessWidget {
  const GetProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Product Found"));
          }

          var data = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var product = data[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ---------- PRODUCT IMAGE ----------
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: product["image"] != null
                            ? Image.file(
                                File(product["image"]),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Icon(Icons.image, size: 60),
                      ),
                    ),

                    SizedBox(height: 6),

                    // ---------- PRODUCT NAME ---- ------
                    Text(
                      product["name"],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // ---------- PRODUCT PRICE ----------
                    Text(
                      "Rs. ${product["price"]}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: 6),

                    // ---------- EDIT + DELETE BUTTONS ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController nameController =
                                    TextEditingController(
                                      text: product["name"],
                                    );
                                TextEditingController priceController =
                                    TextEditingController(
                                      text: product["price"].toString(),
                                    );
                                TextEditingController categoryController =
                                    TextEditingController(
                                      text: product["category"],
                                    );
                                TextEditingController descController =
                                    TextEditingController(
                                      text: product["description"],
                                    );

                                return AlertDialog(
                                  title: Text("Edit Product"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: "Enter Product Name",
                                          ),
                                        ),
                                        TextField(
                                          controller: priceController,

                                          decoration: InputDecoration(
                                            labelText: "Enter Price",
                                          ),
                                        ),
                                        TextField(
                                          controller: categoryController,
                                          decoration: InputDecoration(
                                            labelText: "Enter Category",
                                          ),
                                        ),
                                        TextField(
                                          controller: descController,
                                          decoration: InputDecoration(
                                            labelText: "Enter Description",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("products")
                                            .doc(product.id)
                                            .update({
                                              "name": nameController.text,
                                              "price": int.parse(priceController.text),
                                              "category":
                                                  categoryController.text,
                                              "description":
                                                  descController.text,
                                            });
                                        Navigator.pop(context);
                                      },
                                      child: Text("Update"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("products")
                                .doc(product.id)
                                .delete();
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
