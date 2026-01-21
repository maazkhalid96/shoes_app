import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/custom_button.dart';
import 'package:shoes_app_ui/screens/home/admin/add_product.dart';
import 'package:shoes_app_ui/screens/home/admin/admin_order_screen.dart';
import 'package:shoes_app_ui/screens/home/admin/all_users.dart';
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
  int totalProduct = 0;
  int totalOrders = 0;
  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    getAllProducts();
    getAllOrders();
    getAllUsers();
  }

  // Fetch total products
  getAllProducts() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("products")
        .get();
    setState(() {
      totalProduct = snapshot.docs.length;
    });
  }

  // Fetch total orders
  getAllOrders() async {
    var snapshot = await FirebaseFirestore.instance.collection("orders").get();
    setState(() {
      totalOrders = snapshot.docs.length;
    });
  }

  //// Fetch Total Users
  getAllUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection("users").get();

    setState(() {
      totalUsers = snapshot.docs.length;
    });
  }

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
        leading: screen != null
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue.shade400),
                onPressed: () {
                  setState(() {
                    screen = null;
                  });
                },
              )
            : null,
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
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                setState(() {
                  screen = AddProduct();
                });
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
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                setState(() {
                  screen = GetProduct();
                });
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
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                setState(() {
                  screen = AdminOrdersScreen();
                });
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
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                setState(() {
                  screen = Home();
                });
              },
            ),
            Spacer(),
            Center(
              child: CustomButton(
                text: "Login",
                width: 150,
                onPressed: () {
                  setState(() {
                    screen = Login();
                  });
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

  // Dashboard view
  Widget buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, Admin!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Manage your store quickly and efficiently",
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
          SizedBox(height: 25),

          // Row 1
          Row(
            children: [
              Expanded(
                child: BuildDashboardCards(
                  title: "Add Product",
                  icon: Icons.add_box,
                  color: Colors.blue.shade400,
                  onTap: () {
                    setState(() {
                      screen = AddProduct();
                    });
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: BuildDashboardCards(
                  title: "Get Product",
                  subtitle: "Total Products: $totalProduct",
                  icon: Icons.shopping_bag,
                  color: Colors.green.shade400,
                  onTap: () {
                    setState(() {
                      screen = GetProduct();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          // Row 2
          Row(
            children: [
              Expanded(
                child: BuildDashboardCards(
                  title: "All Orders",
                  subtitle: "Total Orders: $totalOrders",
                  icon: Icons.receipt_long,
                  color: Colors.orange.shade400,
                  onTap: () {
                    setState(() {
                      screen = AdminOrdersScreen();
                    });
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: BuildDashboardCards(
                  title: "All Users",
                  subtitle: "Total Users: $totalUsers",
                  icon: Icons.person,
                  color: Colors.purple.shade400,
                  onTap: () {
                    setState(() {
                      screen = AllUsers();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          // Row 3
          Row(
            children: [
              Expanded(
                child: BuildDashboardCards(
                  title: "Home Page",
                  icon: Icons.home,
                  color: Colors.teal.shade400,
                  onTap: () {
                    setState(() {
                      screen = Home();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
