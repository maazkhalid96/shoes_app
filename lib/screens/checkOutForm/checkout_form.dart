import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/screens/checkoutform/order_success_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  final TextEditingController paymentController = TextEditingController();
  String? selectedPayment;

  List<String> payment = ["Cash on Delivery", "Card", 'JazzCash', 'EasyPaisa'];

  bool isLoading = false;

  placeOrder() async {
    setState(() => isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection("carts")
        .doc(uid)
        .collection("items")
        .get();

    if (cartSnapshot.docs.isEmpty) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your cart is empty!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<Map<String, dynamic>> cartItems = [];
    int total = 0;

    for (var doc in cartSnapshot.docs) {
      var item = doc.data();
      int price = int.parse(item["price"].toString());
      int quantity = int.parse(item["quantity"].toString());
      total += price * quantity;
      cartItems.add({
        "id": doc.id,
        "name": item["name"],
        "price": price,
        "quantity": quantity,
      });
    }

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
      "estimatedDelivery": Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 5)),
      ),
      "totalAmount": total,
      "paymentMethod": selectedPayment,
      "items": cartItems,
    });

    // Clear cart
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    if (!mounted) return;
    setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
    );
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    if (!serviceEnabled) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled.")),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permission denied permanently, enable it from settings",
          ),
        ),
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];

    if (!mounted) return;
    setState(() {
      addressController.text =
          "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}";
      cityController.text = place.locality ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            CustomInputField(
              hintText: "Full Name",
              prefixIcon: Icons.person,
              controller: nameController,
              textInputType: TextInputType.name,
            ),
            CustomInputField(
              hintText: "Phone Number",
              prefixIcon: Icons.phone,
              controller: phoneController,
              textInputType: TextInputType.phone,
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
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
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text("Use Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                await getCurrentLocation();
              },
            ),
            DropdownButtonFormField(
              value: selectedPayment,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.payment_outlined, color: Colors.blue),
                hintText: "Payment",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),

              items: payment.map((String option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPayment = newValue;
                });
              },
            ),

            const SizedBox(height: 30),

            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : CustomButton(
                    text: "Place Order",
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          selectedPayment == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (phoneController.text.length < 11) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter valid phone number"),
                            backgroundColor: Colors.red,
                          ),
                        );
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
