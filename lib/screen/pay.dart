import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart'; // Import your order page

class Payy extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final double basketTotal;

  const Payy({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.basketTotal,
  }) : super(key: key);

  @override
  State<Payy> createState() => _PayyState();
}

class _PayyState extends State<Payy> {
  final List<Map<String, String>> paymentOptions = [
    {
      "title": "Cash on Delivery",
      "img": "assets/cd.png", // Replace with your asset path
    },
    {
      "title": "UPI Payment",
      "img": "assets/upi.png", // Replace with your asset path
    },
    {
      "title": "Bank Transfer",
      "img": "assets/bank.png", // Replace with your asset path
    },
  ];

  int? selectedIndex; // Track the index of the selected item
  String? selectedPaymentMethod;

  Future<void> _storeOrderInFirestore() async {
    final orderData = {
      'items': widget.cartItems,
      'totalPrice': widget.totalPrice,
      'basketTotal': widget.basketTotal,
      'paymentMethod': selectedPaymentMethod,
      'date': Timestamp.now(),
      'status': 'active', // Set status as 'active' or change as needed
    };

    await FirebaseFirestore.instance.collection('orders').add(orderData);
  }

  void _navigateToOrderPage() {
    if (selectedPaymentMethod != null) {
      _storeOrderInFirestore(); // Store the order in Firestore
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Order1(
            cartItems: widget.cartItems,
            totalPrice: widget.totalPrice,
            userId: '', // Add appropriate userId
          ),
        ),
      );
    } else {
      // Show a message if no payment method is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a payment method.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
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
                      "Payment Method",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: paymentOptions.length,
                  itemBuilder: (context, index) {
                    final option = paymentOptions[index];
                    bool isSelected = selectedIndex == index;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIndex = null; // Collapse if already selected
                                selectedPaymentMethod = null;
                              } else {
                                selectedIndex = index; // Expand the clicked item
                                selectedPaymentMethod = option["title"];
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                option["img"]!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                option["title"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _navigateToOrderPage,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Pay ${widget.totalPrice.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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



