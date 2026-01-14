import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoes_app_ui/components/profile_menu_item.dart';
import 'package:shoes_app_ui/screens/edit_profile/edit_profile.dart';
import 'package:shoes_app_ui/screens/profile/address/address.dart';
import 'package:shoes_app_ui/screens/profile/my_favorites/my_favorites.dart';
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
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
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
          child: StreamBuilder(
            stream: firestore
                .collection("users")
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: 20.r,
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
                      radius: 80.r,
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
                    SizedBox(height: 15.h),

                    //  Username
                    Text(
                      usersData['username'] ?? "No Name",
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // email
                    Text(
                      usersData['email'] ?? "No Email",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 25.h),

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
                          thickness: 1.h,
                          indent: 20.w,
                          endIndent: 20.w,
                        ),

                        ProfileMenuItem(
                          icon: Icons.favorite,
                          iconColor: Colors.pink,

                          title: "Wishlist",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyFavorites(),
                              ),
                            );
                          },
                        ),
                        Divider(
                          color: Colors.white30,
                          thickness: 1.h,
                          indent: 20.w,
                          endIndent: 20.w,
                        ),

                        ProfileMenuItem(
                          icon: Icons.location_on,
                          title: "Address",
                          iconColor: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Address(),
                              ),
                            );
                          },
                        ),
                        Divider(
                          color: Colors.white30,
                          thickness: 1.h,
                          indent: 20.w,
                          endIndent: 20.w,
                        ),

                        ProfileMenuItem(
                          icon: Icons.settings,
                          iconColor: Colors.grey,

                          title: "Settings",
                          onTap: () {},
                        ),
                        Divider(
                          color: Colors.white30,
                          thickness: 1.h,
                          indent: 20.w,
                          endIndent: 20.w,
                        ),

                        ProfileMenuItem(
                          icon: Icons.payment,
                          iconColor: Colors.orange,

                          title: "Payment",
                          onTap: () {},
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (!context.mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,

                                    padding: EdgeInsets.symmetric(
                                      vertical: 15.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Sign Out",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditProfile(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
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
      ),
    );
  }
}
