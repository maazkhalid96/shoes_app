import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderDetail extends StatelessWidget {
  final String orderId;
  const AdminOrderDetail({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Order Not Found"));
          }

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final List items = order["items"] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///  Order Header
                Card(
                  child: ListTile(
                    title: const Text(
                      "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(orderId),
                    trailing: Text(
                      order["status"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Product Details
                const Text(
                  "Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item["name"]),
                        subtitle: Text("Qty: ${item["quantity"]}"),
                        trailing: Text(
                          "${item["price"]} PKR",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                ///  Total Amount
                Card(
                  color: Colors.green.shade50,
                  child: ListTile(
                    title: const Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      "${order["totalAmount"]} PKR",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                ///  Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("orders")
                              .doc(orderId)
                              .update({"status": "Cancelled"});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order Cancelled")),
                          );
                        },
                        child: const Text("Cancel Order"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: order["status"] == "Cancelled"
                            ? null
                            : () async {
                                String status = order["status"];

                                if (status == "Pending") {
                                  status = "Shipped";
                                } else if (status == "Shipped") {
                                  status = "Delivered";
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Order already delivered"),
                                    ),
                                  );
                                  return;
                                }
                                await FirebaseFirestore.instance
                                    .collection("orders")
                                    .doc(orderId)
                                    .update({"status": status});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Status Updated to"),
                                  ),
                                );
                              },
                        child: const Text("Update Status"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
