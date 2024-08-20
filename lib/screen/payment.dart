import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ac.dart'; // Ensure this file exists and is correctly implemented
import 'order.dart'; // Ensure this file exists and is correctly implemented
import 'pay.dart'; // Ensure this file exists and is correctly implemented

class Payment extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final double basketTotal;

  const Payment({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.basketTotal,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int? selectedMethodIndex;
  List<DocumentSnapshot> cardDocuments = [];

  @override
  void initState() {
    super.initState();
    _fetchCardsFromFirestore();
  }

  Future<void> _fetchCardsFromFirestore() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('card').get();
    setState(() {
      cardDocuments = querySnapshot.docs;
    });
  }

  Future<void> _removeCardFromFirestore(String cardId) async {
    await FirebaseFirestore.instance.collection('card').doc(cardId).delete();
    _fetchCardsFromFirestore(); // Refresh the card list after deletion
  }

  Future<void> _storeOrderInFirestore(String paymentMethod) async {
    final orderData = {
      'items': widget.cartItems,
      'totalPrice': widget.totalPrice,
      'basketTotal': widget.basketTotal,
      'paymentMethod': paymentMethod,
      'date': Timestamp.now(),
      'status': 'active', // Set status as 'active' or change as needed
    };

    await FirebaseFirestore.instance.collection('orders').add(orderData);
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
                SizedBox(height: 25),
                ...cardDocuments.map((cardDoc) {
                  Map<String, dynamic> cardData =
                  cardDoc.data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(cardDoc.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeCardFromFirestore(cardDoc.id);
                    },
                    background: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
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
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          index: cardDocuments.indexOf(cardDoc),
                          image:
                          "assets/card.png",
                          text: cardData['cardNumber'],
                          subText: cardData['expireDate'],
                          isSelected: selectedMethodIndex ==
                              cardDocuments.indexOf(cardDoc),
                        ),
                        SizedBox(height: 17),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Ac()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 57,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(216, 237, 249, 1),
                      borderRadius: BorderRadius.circular(57),
                    ),
                    child: Center(
                      child: Text(
                        "ADD CARD  +",
                        style: TextStyle(
                          color: Color.fromRGBO(13, 94, 249, 1),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  "Other Methods",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 15),
                _buildPaymentOption(
                  index: cardDocuments.length,
                  image: "assets/cashapp.png",
                  text: "Cash Payment",
                  subText: "Default Method",
                  isSelected: selectedMethodIndex == cardDocuments.length,
                  onTap: () async {
                    // Store order with "Cash Payment" as the payment method
                    await _storeOrderInFirestore("Cash Payment");

                    // Navigate to the Payy page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payy(
                          cartItems: widget.cartItems,
                          totalPrice: widget.totalPrice,
                          basketTotal: widget.basketTotal,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 137,
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
                            "+ AED ${widget.totalPrice.toStringAsFixed(2)}",
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
                            "- AED 10.00", // Example discount
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Divider(),
                      SizedBox(height: 4),
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
                            "AED ${widget.basketTotal.toStringAsFixed(2)}",
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
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Order1(
                          cartItems: widget.cartItems,
                          totalPrice: widget.totalPrice,
                          userId:
                          'some_user_id', // Replace with actual user ID
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 215,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 8),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "ORDER NOW",
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
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String image,
    required String text,
    required String subText,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethodIndex = index;
        });
        if (onTap != null) onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(image, width: 50, height: 50,),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


