import 'package:flutter/material.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3),(){
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Login()),
      );
    } );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage("assets/images/banner.jpg"),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Welcome to VIP App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Experience luxury at your fingertips",
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
    );
  }
}
