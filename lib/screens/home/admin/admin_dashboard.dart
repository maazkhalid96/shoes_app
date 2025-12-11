import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/screens/home/admin/add_product.dart';
import 'package:shoes_app_ui/screens/home/admin/get_product.dart';
import 'package:shoes_app_ui/screens/home/home.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget screen = AddProduct();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Paneel",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade400,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: DrawerHeader(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
            ),

            // Add Product
            ListTile(
              title: Text("Add Product",style: TextStyle(fontSize: 25 ,color: Colors.black87,fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  screen = AddProduct();
                });
                Navigator.pop(context);
              },
            ),
            // Get Product
            ListTile(
              title: Text("Get Product",style: TextStyle(fontSize: 25 ,color: Colors.black87,fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  screen = GetProduct();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Home Page",style: TextStyle(fontSize: 25 ,color: Colors.black87,fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            Spacer(),
            Center(
              child: CustomButton(
                text: "Login",
                width: 150,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
            // ListTile(

            //   title: Text("Login",style: TextStyle(fontSize: 25 ,color: Colors.black87,fontWeight: FontWeight.bold),),
            //   onTap: () {

            //   },
            // ),
          ],
        ),
      ),
      body: screen,
    );
  }
}
