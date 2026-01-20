import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/screens/home/admin/add_product.dart';
import 'package:shoes_app_ui/screens/home/admin/admin_order_screen.dart';
import 'package:shoes_app_ui/screens/home/admin/build_dashboard_cards.dart';
import 'package:shoes_app_ui/screens/home/admin/get_product.dart';
import 'package:shoes_app_ui/screens/home/home.dart';
import 'package:shoes_app_ui/screens/signup/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget? screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade400,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue.shade400),
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(
                "Add Product",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              onTap: () {
                setState(() {
                  screen = AddProduct();
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text(
                "Get Product",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              onTap: () {
                setState(() {
                  screen = GetProduct();
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text(
                "All Orders",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              onTap: () {
                setState(() {
                  screen = AdminOrdersScreen();
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home Page",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
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
            SizedBox(height: 20),
          ],
        ),
      ),
      body: screen ?? buildDashboard(),
    );
  }


  Widget buildDashboard() {
    return Container(
      color: Colors.blue.shade50,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, Admin!",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700),
          ),
          SizedBox(height: 10),
          Text(
            "Manage your store quickly and efficiently",
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
          SizedBox(height: 25),

          // Two rows with 2 cards each
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    BuildDashboardCards(
                      title: "Add Product",
                      icon: Icons.add_box,
                      color: Colors.blue.shade400,
                      onTap: () {
                        setState(() {
                          screen = AddProduct();
                        });
                      },
                    ),
                    BuildDashboardCards(
                      title: "Get Product",
                      icon: Icons.shopping_bag,
                      color: Colors.green.shade400,
                      onTap: () {
                        setState(() {
                          screen = GetProduct();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    BuildDashboardCards(
                      title: "All Orders",
                      icon: Icons.receipt_long,
                      color: Colors.orange.shade400,
                      onTap: () {
                        setState(() {
                          screen = AdminOrdersScreen();
                        });
                      },
                    ),
                    BuildDashboardCards(
                      title: "Home Page",
                      icon: Icons.home,
                      color: Colors.purple.shade400,
                      onTap: () {
                        setState(() {
                          screen = Home();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
