import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoes_app_ui/auth/login_auth.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/components/custom_input_fields.dart';
import 'package:shoes_app_ui/controller/controller.dart';
import 'package:shoes_app_ui/screens/forgotPassword/forgot_password.dart';
import 'package:shoes_app_ui/screens/signup/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController getController = LoginController();
  bool isLoading = false;

  // googleSignIn() async {
  //   String clientId =
  //       '879448455612-su8rdbnovc10id3irdfhh163v8cieohh.apps.googleusercontent.com';
  //   try {
  //     GoogleSignIn signIn = GoogleSignIn.instance;

  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(flip: true),
              child: Container(
                height: 320.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.w),
                    bottomRight: Radius.circular(60.w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Shoes Shop",
                        style: TextStyle(
                          fontSize: 35.sp,
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
              padding: EdgeInsets.all(25.0.w),
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
                  SizedBox(height: 35.h),
                  CustomButton(
                    text: "Log in",
                    isLoading: isLoading,
                    onPressed: () async {
                      setState(() => isLoading = true);

                      await Future.delayed(const Duration(milliseconds: 50));
                      if (!context.mounted) return;

                      await LoginAuth().login(
                        email: getController.emailController.text,
                        password: getController.passwordController.text,
                        emailController: getController.emailController,
                        passwordController: getController.passwordController,
                        context: context,
                      );

                      if (!mounted) return;

                      setState(() => isLoading = false);
                    },
                  ),

                  // isLoading
                  //     ? CircularProgressIndicator()
                  //     : CustomButton(
                  //         text: "Login in",
                  //         onPressed: () async {
                  //           setState(() {
                  //             isLoading = true;
                  //           });
                  //           await LoginAuth().login(
                  //             email: getController.emailController.text,
                  //             password: getController.passwordController.text,
                  //             emailController: getController.emailController,
                  //             passwordController:
                  //                 getController.passwordController,
                  //             context: context,
                  //           );
                  //           setState(() {
                  //             isLoading = false;
                  //           });
                  //         },
                  //       ),
                  SizedBox(height: 25.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      "Continue with goggle",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 14.sp),
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
                          child: Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(fontSize: 14.sp),
                          ),
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
