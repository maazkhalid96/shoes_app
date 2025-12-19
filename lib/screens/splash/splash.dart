import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/home/home.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool fadeOut = false;

  @override
  void initState() {
    super.initState();

    // 2.5 sec ke baad fade-out start
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => fadeOut = true);
    });

    // 3 sec ke baad Login page open

    Future.delayed(const Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
  Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Login()),
        );
    //   if (user != null) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => Home()),
    //     );
    //     print("User is logged in: ${user.email}");
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => Login()),
    //     );
    //     print("User is not logged in");
    //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: fadeOut ? 0.0 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan.shade900, Colors.lightBlueAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 20),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage("assets/images/banner.jpg"),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Welcome to Shoes Shop",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Comfort • Quality • Style",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
