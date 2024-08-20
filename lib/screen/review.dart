import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'menu.dart';

class Track extends StatefulWidget {
  final String orderId;

  Track({required this.orderId});

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  Future<DocumentSnapshot> getOrderDetails() {
    return _firestore.collection('orders').doc(widget.orderId).get();
  }

  void _submitReview() async {
    String comment = _commentController.text;

    // Create a new document in the 'reviews' collection
    await _firestore.collection('reviews').add({
      'orderId': widget.orderId,  // Link the review to the order
      'rating': _rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),  // Optional: add timestamp
    });

    // Optionally, show a confirmation or navigate to another page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted successfully')),
    );
  }

  void _cancelReview() {
    {
      _rating = 0.0;
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Menu(),
                          ),
                              (route) => false, // Remove all previous routes
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: Size(52, 52),
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue.withOpacity(0.8),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/back.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      "My Orders",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<DocumentSnapshot>(
                future: getOrderDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('Order not found'));
                  }

                  var order = snapshot.data!.data() as Map<String, dynamic>;
                  int totalPrice = (order['totalPrice'] as num).toInt();
                  List<dynamic> items = order['items'] ?? [];

                  // Get the image of the first item
                  String firstItemImage =
                  items.isNotEmpty ? items[0]['image'] : '';

                  // Get the total items count
                  int totalItemsCount = items.fold<int>(0, (sum, item) {
                    int quantity = (item['quantity'] as num).toInt();
                    return sum + quantity;
                  });

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (firstItemImage.isNotEmpty)
                              Image.network(
                                firstItemImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$totalItemsCount Items',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                "Re-Order",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "How Is It!",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Your overall rating",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: RatingBar.builder(
                            initialRating: 0, // Example initial rating
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              {
                                _rating = rating;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Add Detailed Review",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: _commentController,
                            maxLines: 4, // Limit the number of lines for better layout control
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Leave a Comment',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              "assets/camera.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded( // To ensure text wraps within available space
                              child: Text(
                                "add Photo",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: _cancelReview,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.blue, width: 2), // Blue outline
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _submitReview,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
