import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/profile_menu_item.dart';
import 'package:shoes_app_ui/screens/profile/my_orders/my_order_screen.dart';
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
      body: SingleChildScrollView(
        child: Container(
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
                          ? NetworkImage(usersData["profileImagePath"])
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrderScreen(),
                              ),
                            );
                          },
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
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          child: CustomButton(
                            text: "Sign Out",
                           onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (!context.mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()),
                                      (route) => false,
                                    );
                                  },
                          ),
                        ),
                        // SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: CustomButton(
                            text: "Edit Profile",
                            backgroundColor: Colors.red,
                            onPressed: () {},
                          ),
                        ),

                        //                        Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 20.w, // responsive horizontal padding
                        //     vertical: 20.h,   // responsive vertical padding
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: CustomButton(
                        //           text: "Sign Out",
                        //           onPressed: () async {
                        //             await FirebaseAuth.instance.signOut();
                        //             if (!context.mounted) return;
                        //             Navigator.pushAndRemoveUntil(
                        //               context,
                        //               MaterialPageRoute(builder: (context) => Login()),
                        //               (route) => false,
                        //             );
                        //           },
                        //           backgroundColor: Colors.redAccent,
                        //           height: 50.h,  // responsive height
                        //           textColor: Colors.white,
                        //         ),
                        //       ),
                        //       SizedBox(width: 8.w), // responsive spacing
                        //       Expanded(
                        //         child: CustomButton(
                        //           text: "Edit Profile",
                        //           onPressed: () {},
                        //           backgroundColor: Colors.blueAccent,
                        //           height: 50.h,
                        //           textColor: Colors.white,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
