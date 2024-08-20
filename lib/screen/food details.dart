import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_food/screen/payment.dart';

import 'deliver add.dart';
import 'oredrlist.dart';

class Foodd extends StatefulWidget {
  final Map<String, dynamic> data;

  const Foodd({Key? key, required this.data}) : super(key: key);

  @override
  _FooddState createState() => _FooddState();
}

class _FooddState extends State<Foodd> {
  double _rating = 0;
  int _quantity = 1;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String name = widget.data['name'];
    String sub = widget.data['sub name'];
    // Convert the price to double using double.parse()
    double pricePerUnit = double.parse(widget.data['price']);
    double totalPrice = pricePerUnit * _quantity;
    String image = widget.data['img'];

    String description = "Chicken burger is a product line of Hum Burgers sold by Indian's Cafe of Burger King fast food restaurants. Delicious and popular. "
        "This description goes on and on to show how you can handle very long text. More details can be added here as needed.";

    String shortDescription = description.length > 100 ? description.substring(0, 100) + '...' : description;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Center(
                    child: Image.network(image),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              Image.network(image, height: 50, width: 50),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    sub,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 3),
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 22.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (_quantity > 1) {
                                      _quantity--;
                                    }
                                  });
                                },
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '$_quantity',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: _isExpanded
                                    ? description
                                    : shortDescription,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              if (description.length > 100)
                                TextSpan(
                                  text: _isExpanded
                                      ? ' Read less'
                                      : ' Read more',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _placeOrder(context);
                          },
                          child: Center(
                            child: Container(
                              width: 261,
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
                                  "PLACE MY ORDER",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) async {
    // Assuming you have this information from widget.data or similar:
    List<Map<String, dynamic>> cartItems = [
      {
        'name': widget.data['name'],
        'image': widget.data['img'],
        'quantity': _quantity,
        'price': widget.data['price'],
      },
      // Add more items if needed
    ];

    double totalPrice = double.parse(widget.data['price']) * _quantity;

    // Navigate to Add Page
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Add(
          cartItems: cartItems,
          totalPrice: totalPrice,
          basketTotal: totalPrice,
        ),
      ),
    );

    if (result == true) {
      // Navigate to Payment Page if Add Page is completed
      var paymentResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(
            totalPrice: totalPrice,
            cartItems: cartItems,
            basketTotal: totalPrice,
          ),
        ),
      );

      if (paymentResult == true) {
        // After Payment Page, store the order in Firestore and navigate to Track Page
        _storeOrderInFirestore(cartItems, totalPrice);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Oredrlist()),
        );
      }
    }
  }

  void _storeOrderInFirestore(
      List<Map<String, dynamic>> cartItems, double totalPrice) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'items': cartItems,
        'totalPrice': totalPrice,
        'status': 'active', // Initial status
        'date': DateTime.now(), // Order date
      });
      print('Order stored in Firestore');
    } catch (e) {
      print('Error storing order: $e');
    }
  }
}

