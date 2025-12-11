import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shoes_app_ui/auth/login_auth.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/controller/controller.dart';
import 'package:shoes_app_ui/screens/signup/signup.dart';

class Login extends StatelessWidget {
   Login({super.key});
  LoginController getController = LoginController();

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
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Shoes Shop",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  CustomInputField(
                    hintText: "Enter Email",
                    controller: getController.emailController,
                    prefixIcon: Icons.email_outlined,
                  ),
                  
                  CustomInputField(
                    hintText: "Enter Password",
                    controller: getController.passwordController,
                    obscureText: true,
                    prefixIcon: Icons.remove_red_eye,
                  ),
                  SizedBox(height: 35),
                  CustomButton(
                    text: "Login in",
                    onPressed: () {
                      LoginAuth().login(
                        email: getController.emailController.text,
                        password: getController.passwordController.text,
                        emailController: getController.emailController,
                        passwordController: getController.passwordController,
                        context: context,
                      );
                    },
                  ),
                  SizedBox(height: 25),

                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Center(
                          child: Text("Don't have an account? Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
