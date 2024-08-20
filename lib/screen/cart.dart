import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'deliver add.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key, required List items}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Stream<List<Map<String, dynamic>>> _cartItemsStream;

  @override
  void initState() {
    super.initState();
    _cartItemsStream = FirebaseFirestore.instance
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id, // Ensure that each item has an 'id' field
                  ...doc.data() as Map<String, dynamic>
                })
            .toList());
  }

  double getTotalPrice(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0, (total, item) {
      double price =
          double.tryParse(item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ??
              0;
      int quantity =
          item['quantity'] ?? 1; // Default to 1 if quantity is not set
      return total + (price * quantity);
    });
  }

  void _updateQuantity(String id, int newQuantity) {
    FirebaseFirestore.instance.collection('cart').doc(id).update({
      'quantity': newQuantity,
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quantity'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _cartItemsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                'No items in cart',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 30  ),
              ));
            }

            List<Map<String, dynamic>> cartItems = snapshot.data!;
            double totalPrice = getTotalPrice(cartItems);
            double discount = 10; // Example discount
            double basketTotal = totalPrice - discount;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 9,
                                spreadRadius: 1,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/back.png",
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Order details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Search and Filter
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
                  // SizedBox(height: 25),

                  // Scrollable ListView
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = cartItems[index];
                        int quantity = item['quantity'] ?? 1;
                        return Dismissible(
                          key: Key(item[
                              'id']), // Use 'id' to uniquely identify each item
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            // Delete item from Firestore
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(item[
                                    'id']) // Use the 'id' to delete the specific document
                                .delete()
                                .then((_) {
                              // Show confirmation message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item['name']} removed'),
                                ),
                              );
                            }).catchError((error) {
                              // Handle error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Failed to remove ${item['name']}'),
                                ),
                              );
                            });
                          },
                          background: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.blue,
                              size: 25,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(216, 237, 249, 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 84,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: NetworkImage(item['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 27),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          item['price'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity adjustment buttons
                                  Container(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Row to ensure even spacing between buttons and text
                                          Row(
                                            children: [
                                              // Button to decrease quantity
                                              IconButton(
                                                icon: Icon(Icons.remove,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  if (quantity > 1) {
                                                    _updateQuantity(item['id'],
                                                        quantity - 1);
                                                  }
                                                },
                                              ),
                                              // Text displaying the quantity
                                              Text(
                                                '$quantity',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // Button to increase quantity
                                              IconButton(
                                                icon: Icon(Icons.add,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  _updateQuantity(
                                                      item['id'], quantity + 1);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 35),
                  // Totals and Checkout Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 145,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(24, 30, 34, 0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Basket Total",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "+ USD ${totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(24, 30, 34, 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discount",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "- USD ${discount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  " USD ${basketTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 48),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Add(
                                cartItems: cartItems,
                                totalPrice: totalPrice,
                                basketTotal: basketTotal,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            width: 261,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: Offset(0, 9),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "PLACE MY ORDER",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15)
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
