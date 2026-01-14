import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  ////  loader  ///
  bool isLoading = false;

  ///   controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  ////// get current user  //////
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  savedAddress() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("address")
        .doc("default")
        .set({
          "name": nameController.text,
          "phone": phoneController.text,
          "street": streetController.text,
          "city": cityController.text,
          "zipcode": zipController.text,
        });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Address saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  loadSavedAddress() async {
    var address = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("address")
        .doc("default")
        .get();
    if (address.exists) {
      var data = address.data()!;

      setState(() {
        
      nameController.text = data["name"] ?? '';
      phoneController.text = data["phone"] ?? '';
      streetController.text = data["street"] ?? '';
      cityController.text = data["city"] ?? '';
      zipController.text = data["zipcode"] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(hintText: "Name", controller: nameController),
              SizedBox(height: 15),
              CustomInputField(
                hintText: "Phone",
                controller: phoneController,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              SizedBox(height: 15),
              CustomInputField(
                hintText: "Street",
                controller: streetController,
              ),
              SizedBox(height: 15),
              CustomInputField(hintText: "City", controller: cityController),
              SizedBox(height: 15),
              CustomInputField(
                hintText: "Zip Code / Postal Code",
                controller: zipController,
              ),
              SizedBox(height: 25),
              CustomButton(
                isLoading: isLoading,
                text: "Save Address",
                width: 230,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      streetController.text.isEmpty ||
                      cityController.text.isEmpty ||
                      zipController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill all fields"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (phoneController.text.length != 11) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Enter a valid 11-digit phone number"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (zipController.text.length != 5 &&
                      zipController.text.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Enter a valid postal code"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  await savedAddress();
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
