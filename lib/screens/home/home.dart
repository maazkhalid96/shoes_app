  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:shoes_app_ui/components/slider_banner.dart';
  import 'package:shoes_app_ui/screens/carts/carts_data.dart';
  import 'package:shoes_app_ui/screens/detail/product_detail.dart';
  import 'package:shoes_app_ui/screens/home/favorite/product_favorite.dart';
  import 'package:shoes_app_ui/screens/profile/profile.dart';

  class Home extends StatefulWidget {
    const Home({super.key});

    @override
    State<Home> createState() => _HomeState();
  }

  PageController pageController = PageController();
  int currentPage = 0;

  class _HomeState extends State<Home> {
    late Future<DocumentSnapshot> userFuture;
    TextEditingController searchController = TextEditingController();
    String searchText = "";
    Map<String, bool> favoriteStatus = {};
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<String> categories = ["All", "Men Shoes", "Women Shoes", "Kids Shoes"];

    String selectedCategory = "All";

    @override
    void initState() {
      super.initState();
      userFuture = firestore.collection("users").doc(auth.currentUser!.uid).get();
    }

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );
              },
              child: FutureBuilder<DocumentSnapshot>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      radius: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return CircleAvatar(radius: 20, child: Icon(Icons.person));
                  }

                  var usersData = snapshot.data!.data() as Map<String, dynamic>;

                  return CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        (usersData['profileImagePath'] != null &&
                            usersData['profileImagePath'] != "")
                        ? NetworkImage(usersData["profileImagePath"])
                        : null,
                    child:
                        (usersData['profileImagePath'] == null ||
                            usersData['profileImagePath'] == "")
                        ? Icon(Icons.person)
                        : null,
                  );
                },
              ),
            ),
          ),
          title: Center(
            child: Text(
              "Shoes Shop",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: Colors.blueAccent),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartsData()),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // --- Search Bar ---
                TextField(
                  controller: searchController,
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
                  onChanged: (value) {
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                ),

                SizedBox(height: 20),

                // --- Slider Banner ---
                Container(
                  height: 260,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: SliderBanner(
                            title: "Best Sellers",
                            subTitle: "Trending Now",
                            collection: "Collection",
                            imagePath: "assets/images/banner2.jpg",

                            callback: () {},
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: double.infinity,

                          child: SliderBanner(
                            title: "Limited Edition",
                            subTitle: "Exclusive 2024",
                            collection: "Collection",
                            imagePath: "assets/images/banner3.jpg",
                            callback: () {},
                          ),
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
                // --- Categories Row ---
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      String category = categories[index];
                      bool isSelected = category == selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // --- Products Grid ---
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No products found"));
                    }

                    var allProducts = snapshot.data!.docs;

                    var filteredProducts = allProducts.where((product) {
                      String name = product["name"].toString().toLowerCase();
                      String productCategory = product["category"];

                      bool searchMatch = name.contains(searchText);

                      bool categoryMatch =
                          selectedCategory == "All" ||
                          productCategory == selectedCategory;
                      return searchMatch && categoryMatch;
                    }).toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        var data = filteredProducts[index].data();
                        data["id"] = filteredProducts[index].id;

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
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: data["image"] != null
                                        ? Image.network(
                                            data["image"],
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
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
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
                                      GestureDetector(
                                        onTap: () async{
                                          setState(() {
                                            String productId = data["id"];

                                            favoriteStatus[productId] =
                                                !(favoriteStatus[productId] ??
                                                    false);
                                          });
                                        await  ProductFavorite().addFavorite(data);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color:
                                              (favoriteStatus[data["id"]] ??
                                                  false)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
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
