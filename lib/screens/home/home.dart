import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app_ui/components/slider_banner.dart';
import 'package:shoes_app_ui/screens/detail/product_detail.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();
  int currentPage = 0;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Shoes Shop",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.blueAccent, // Text color
              letterSpacing: 2, // Letters ke beech spacing
              shadows: [
                Shadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(2, 2),
                  blurRadius: 3,
                ),
              ], // Thoda shadow effect
            ),
          ),
        ),

        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 245, 230, 230),
                  hintText: "Search shoes",
                  filled: true,

                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                height: 250,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SliderBanner(
                        title: "New Arrivals",
                        subTitle: "Summer 2024",
                        collection: "Collection",
                        imagePath: "assets/images/banner1.jpg",
                        callback: () {},
                      ),
                    ),

                    // SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SliderBanner(
                        title: "Best Sellers",
                        subTitle: "Trending Now",
                        collection: "Collection",
                        imagePath: "assets/images/banner2.jpg",
                        callback: () {},
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SliderBanner(
                        title: "Limited Edition",
                        subTitle: "Exclusive 2024",
                        collection: "Collection",
                        imagePath: "assets/images/banner3.jpg",
                        callback: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 12 : 8,
                    height: currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No data Found"));
                  }
                  var product = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      var data = product[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(product: data),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---------- IMAGE ----------
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: data["image"] != null
                                      ? Image.file(
                                          File(data["image"]),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 70,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),

                              SizedBox(height: 10),

                              // ---------- NAME ----------
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  data["name"],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              SizedBox(height: 6),

                              // ---------- PRICE ----------
                              Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Rs. ${data["price"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
