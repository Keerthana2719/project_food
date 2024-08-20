import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_food/screen/menu.dart';
import 'package:project_food/screen/oredrlist.dart';

class Order1 extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final String userId;

  const Order1({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.userId,
  }) : super(key: key);

  @override
  State<Order1> createState() => _Order1State();
}

class _Order1State extends State<Order1> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _storeOrderInFirebase() async {
    try {
      await _firestore.collection('orders').add({
        'userId': widget.userId,
        'items': widget.cartItems,
        'totalPrice': widget.totalPrice,
        'date': Timestamp.now(),
        'status': 'active', // Initial status
      });
    } catch (e) {
      print("Error storing order: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _storeOrderInFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Menu()), // Navigate to Home
              (route) => false,
        );
        return false; // Prevent default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 190),
                  Center(
                    child: Image.asset(
                      "assets/finish.png",
                      width: 260,
                      height: 151,
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "You successfully made a payment,",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "enjoy our service!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 120),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Oredrlist()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 62,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "TRACK ORDER",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "View E-receipt",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
