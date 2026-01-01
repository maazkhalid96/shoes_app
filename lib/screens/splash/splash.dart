import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';

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

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => fadeOut = true);
    });


    Future.delayed(const Duration(seconds: 3), () {
  Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Login()),
        );

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
