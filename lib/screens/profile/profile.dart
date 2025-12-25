import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/profile_menu_item.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: firestore
              .collection("users")
              .doc(auth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                radius: 20,
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return CircleAvatar(radius: 20, child: Icon(Icons.person));
            }

            var usersData = snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (usersData['profileImagePath'] != null &&
                            usersData['profileImagePath'] != "")
                        ? FileImage(File(usersData['profileImagePath']))
                        : null,
                    child:
                        (usersData['profileImagePath'] == null ||
                            usersData['profileImagePath'] == "")
                        ? Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(height: 15),

                  //  Username
                  Text(
                    usersData['username'] ?? "No Name",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),

                  // email
                  Text(
                    usersData['email'] ?? "No Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 25),

                  Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.shopping_bag,
                        iconColor: Colors.blueAccent,
                        title: "My Orders",
                        onTap: () {},
                      ),
                      Divider(
                        color: Colors.white30,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),

                      ProfileMenuItem(
                        icon: Icons.favorite,
                        iconColor: Colors.pink,

                        title: "Wishlist",
                        onTap: () {},
                      ),
                      Divider(
                        color: Colors.white30,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),

                      ProfileMenuItem(
                        icon: Icons.location_on,
                        title: "Address",
                        iconColor: Colors.green,
                        onTap: () {},
                      ),
                      Divider(
                        color: Colors.white30,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),

                      ProfileMenuItem(
                        icon: Icons.settings,
                        iconColor: Colors.grey,

                        title: "Settings",
                        onTap: () {},
                      ),
                      Divider(
                        color: Colors.white30,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),

                      ProfileMenuItem(
                        icon: Icons.payment,
                        iconColor: Colors.orange,

                        title: "Payment",
                        onTap: () {},
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: "Sign Out",

                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                backgroundColor: Colors.redAccent,
                                height: 50,
                                width: 50,
                                textColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                text: "Edit Profile",
                                onPressed: () {},
                                backgroundColor: Colors.blueAccent,
                                height: 50,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
