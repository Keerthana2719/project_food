import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart.dart';
import 'food details.dart';
 // Fixed path

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  void _addToCart(Map<String, dynamic> item) async {
    try {
      final cartCollection = FirebaseFirestore.instance.collection('cart');
      final itemName = item['name'];

      // Check if the item already exists in the cart
      final querySnapshot = await cartCollection.where('name', isEqualTo: itemName).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Item exists, update its quantity
        final docId = querySnapshot.docs.first.id;
        final docRef = cartCollection.doc(docId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final docSnapshot = await transaction.get(docRef);
          if (!docSnapshot.exists) {
            throw Exception("Document does not exist");
          }

          final currentQuantity = docSnapshot.data()?['quantity'] ?? 0;
          transaction.update(docRef, {'quantity': currentQuantity + 1});
        });

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Increased quantity in Cart'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Item does not exist, add it to the cart with quantity 1
        await cartCollection.add({
          ...item,
          'quantity': 1,  // Initialize quantity as 1
        });

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to Cart'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Handle errors here
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "     Popular Menu",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0), // Adjust the right margin as needed
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart(items: [],),) // Navigate to Cart
                  );
                },
                child: Image.asset(
                  "assets/cart.png",
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Container(
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(54),
                    color: Color.fromRGBO(64, 76, 90, 0.1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Image.asset("assets/search.png", width: 25, height: 25),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search..",
                            hintStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Image.asset("assets/filter.png", width: 20, height: 20),
                      SizedBox(width: 30),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('foods').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    // Filter documents based on searchQuery
                    List<DocumentSnapshot> filteredDocuments = documents.where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      String name = data['name'].toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        mainAxisExtent: 280,
                      ),
                      itemCount: filteredDocuments.length,
                      itemBuilder: (_, index) {
                        Map<String, dynamic> data = filteredDocuments[index].data() as Map<String, dynamic>;

                        String name = data['name'];
                        String sub = data['sub name'];
                        String price = "\$" + data['price'].toString();
                        String image = data['img'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Foodd(data: data),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5),
                                Image.network(
                                  image,
                                  width: double.maxFinite,
                                  height: 140,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  sub,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  price,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _addToCart({
                                        'name': name,
                                        'sub': sub,
                                        'price': price,
                                        'image': image,
                                      });
                                    },
                                    child: Container(
                                      height: 14,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/add.png",
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "ADD TO CART",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
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
      ),
    );
  }
}

