import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/checkoutform/checkout_form.dart';

class CartsData extends StatefulWidget {
  const CartsData({super.key});

  @override
  State<CartsData> createState() => _CartsDataState();
}

class _CartsDataState extends State<CartsData> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoaderProceesing = false;

  Future<void> increaseQty(String cartId, Map item) async {
    int qty = item["quantity"];
    int price = item["price"];

    int upadateqnt = qty + 1;

    await FirebaseFirestore.instance
        .collection("carts")
        .doc(uid)
        .collection("items")
        .doc(cartId)
        .update({"quantity": upadateqnt, "totalPrice": price * upadateqnt});
  }

  Future<void> decreaseQty(String cartId, Map item) async {
    int qty = item["quantity"];
    int price = item["price"];

    if (qty > 1) {
      await FirebaseFirestore.instance
          .collection("carts")
          .doc(uid)
          .collection("items")
          .doc(cartId)
          .update({"quantity": qty - 1, "totalPrice": (qty - 1) * price});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.blueAccent,
      ),

      // TOTAL + CHECKOUT IN ONE ROW
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("carts")
            .doc(uid)
            .collection("items")
            .snapshots(),
        builder: (context, snapshot) {
          int totalAmount = 0;

          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              final item = doc.data() as Map;
              totalAmount += int.parse(item["totalPrice"].toString());
            }
          }

          return Container(
            padding: const EdgeInsets.all(12),
            height: 70,
            child: Row(
              children: [
                // ---- TOTAL PRICE ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        "Rs $totalAmount",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- CHECKOUT BUTTON ----
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutForm()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("carts")
                  .doc(uid)
                  .collection("items")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No items in cart",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                var cartItems = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index].data() as Map;
                    String cartId = cartItems[index].id;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                            child: item["image"] != null
                                ? Image.network(
                                    item["image"],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 60),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Rs ${item["price"]}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["desc"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  increaseQty(cartId, item);
                                },
                              ),
                              Text(
                                item["quantity"].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  decreaseQty(cartId, item);
                                },
                              ),
                            ],
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("carts")
                                  .doc(uid)
                                  .collection("items")
                                  .doc(cartId)
                                  .delete();
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${item["name"]} removed from cart",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
