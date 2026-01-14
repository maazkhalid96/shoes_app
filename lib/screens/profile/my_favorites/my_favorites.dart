import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyFavorites extends StatelessWidget {
  MyFavorites({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // dataSend() async {
  //   try {
  //     await FirebaseFirestore.instance.collection("carts").doc(uid).collection("items").doc
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorites"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("favorites")
            .doc(uid)
            .collection("items")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("There are no favorites yet"));
          }

          var favoritesItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoritesItems.length,
            itemBuilder: (context, index) {
              var item = favoritesItems[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: item["image"] != null
                            ? Image.network(
                                item["image"],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 80),
                        title: Text(item["name"] ?? "No Name"),
                        subtitle: Text("Rs. ${item["price"] ?? "0"}"),
                        trailing: GestureDetector(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("favorites")
                                  .doc(uid)
                                  .collection("items")
                                  .doc(favoritesItems[index].id)
                                  .delete();

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${item['name']} removed from favorites",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),

                      SizedBox(height: 6),

                      // SizedBox(
                      //   width: 150,
                      //   height: 40,
                      //   child: OutlinedButton.icon(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.shopping_cart_outlined, size: 18),
                      //     label: Text("Add to Cart"),
                      //     style: OutlinedButton.styleFrom(
                      //       backgroundColor: Colors.green,
                      //       foregroundColor: Colors.black,
                      //       side: BorderSide(color: Colors.white),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
