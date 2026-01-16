import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/screens/signup/internet_issue.dart';
import 'package:shoes_app_ui/services/cloudinary_service.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoes_app_ui/components/custom_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // pick image////
  File? profileImage;

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  // loader////
  bool isLoading = false;
  //   controlller
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  /// firebase auth && current user
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!;

          userNameController.text = data["username"];
          phoneController.text = data["phone"];
          String imageUrl = data["profileImagePath"] ?? "";

          return Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                CustomInputField(
                  // label: "Enter Name",
                  hintText: "Enter Name",
                  controller: userNameController,
                ),
                SizedBox(height: 15),
                CustomInputField(
                  hintText: "Enter Phone",

                  controller: phoneController,
                ),
                SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : NetworkImage(imageUrl),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: CustomButton(
                    isLoading: isLoading,
                    text: "Profile Update",
                    onPressed: () async {
                       //// check internet connection
                          bool hasInternet = await checkInternet(context);
                          if (!hasInternet) return;
                      setState(() {
                        isLoading = true;
                      });

                      if (userNameController.text.trim().isEmpty ||
                          phoneController.text.trim().isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Fields are required"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      String? finalImageUrl = imageUrl;
                      if (profileImage != null) {
                        finalImageUrl = await CloudinaryService.uploadImage(
                          profileImage!,
                        );
                      }
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .update({
                            "username": userNameController.text,
                            "phone": phoneController.text,
                            "profileImagePath": finalImageUrl,
                          });
                      if (!context.mounted) return;
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Profile Updated"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
