import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';

// Order Success Screen
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text(
                "Order Placed Successfully!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Your shoes will be delivered soon.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Continue Shopping", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Checkout Form
class CheckoutForm extends StatefulWidget {
  const CheckoutForm({super.key});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isLoading = false;

  Future<void> placeOrder() async {
    setState(() => isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final cartSnapshot = await FirebaseFirestore.instance.collection("carts").doc(uid).collection("items").get();

    if (cartSnapshot.docs.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your cart is empty!"), backgroundColor: Colors.red));
      return;
    }

    List<Map<String, dynamic>> cartItems = [];
    int total = 0;

    for (var doc in cartSnapshot.docs) {
      var item = doc.data();
      int price = int.parse(item["price"].toString());
      int quantity = int.parse(item["quantity"].toString());
      total += price * quantity;
      cartItems.add({"id": doc.id, "name": item["name"], "price": price, "quantity": quantity});
    }

    // Unique order ID
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
      "orderId": orderId,
      "userId": uid,
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "city": cityController.text,
      "status": "pending",
      "createdAt": Timestamp.now(),
      "estimatedDelivery": Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
      "totalAmount": total,
      "items": cartItems,
    });

    // Clear cart
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    setState(() => isLoading = false);

    // Navigate to success screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), backgroundColor: Colors.green),
      backgroundColor: const Color(0xfff5f5f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            CustomInputField(hintText: "Full Name", prefixIcon: Icons.person, controller: nameController, textInputType: TextInputType.name),
            CustomInputField(
              hintText: "Phone Number",
              prefixIcon: Icons.phone,
              controller: phoneController,
              textInputType: TextInputType.phone,
              inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
            ),
            CustomInputField(
              hintText: "Complete Address",
              prefixIcon: Icons.location_on,
              controller: addressController,
              maxline: 3,
              textInputType: TextInputType.streetAddress,
            ),
            CustomInputField(
              hintText: "City",
              prefixIcon: Icons.location_city,
              controller: cityController,
              maxline: 1,
              textInputType: TextInputType.text,
            ),

            const SizedBox(height: 30),

            isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.green))
                : CustomButton(
                    text: "Place Order",
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          cityController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      if (phoneController.text.length < 11) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Enter valid phone number"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      placeOrder();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
