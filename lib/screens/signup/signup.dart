import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoes_app_ui/auth/signup_auth.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/controller/signup_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignupController getController = SignupController();

  bool isLoading = false;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(flip: true),
              child: Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Join the Shoes Community",

                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    CustomInputField(
                      controller: getController.userNameController,
                      hintText: "Enter username",
                      prefixIcon: Icons.person_outline,
                    ),
                    CustomInputField(
                      controller: getController.phoneController,
                      hintText: "Enter phone",
                      prefixIcon: Icons.phone_android,
                      textInputType: TextInputType.phone,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    CustomInputField(
                      controller: getController.emailController,
                      hintText: "Enter Email",
                      prefixIcon: Icons.email_outlined,
                    ),
                    CustomInputField(
                      controller: getController.passwordController,
                      hintText: "Enter Password",
                      obscureText: true,
                      prefixIcon: Icons.remove_red_eye,
                    ),
                    SizedBox(height: 35),
                    isLoading
                        ? CircularProgressIndicator()
                        : CustomButton(
                            text: "Sign up",
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              await SignupAuth().signUp(
                                email: getController.emailController.text,
                                password: getController.passwordController.text,
                                username: getController.userNameController.text,
                                phone: getController.phoneController.text,
                                emailController: getController.emailController,
                                userNameController:
                                    getController.userNameController,
                                passwordController:
                                    getController.passwordController,
                                phoneController: getController.phoneController,
                                imagePath: profileImage?.path,
                                context: context,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
