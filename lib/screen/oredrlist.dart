import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'review.dart'; // Ensure the import statement is correct for Track
import 'menu.dart';

class Oredrlist extends StatefulWidget {
  const Oredrlist({super.key});

  @override
  State<Oredrlist> createState() => _OredrlistState();
}

class _OredrlistState extends State<Oredrlist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getOrdersStream() {
    return _firestore.collection('orders').snapshots();
  }

  void _trackOrder(String orderId) {
    // Implement tracking logic here
    print('Track Order: $orderId');
  }

  void _cancelOrder(String orderId) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': 'cancel'});
      print('Order $orderId cancelled');
    } catch (e) {
      print('Error cancelling order: $e');
    }
  }

  void _reorder(String orderId) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': 'complete'});
      print('Order $orderId re-ordered and moved to complete');
    } catch (e) {
      print('Error re-ordering: $e');
    }
  }

  void _deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      print('Order $orderId deleted');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  void _leaveReview(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Track(orderId: orderId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Menu()), // Navigate to Home
              (route) => false, // Remove all previous routes
        );
        return false; // Prevent default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: DefaultTabController(
            length: 3,
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
                            ), // Navigate to Home
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
                SizedBox(height: 18),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    tabs: [
                      Tab(child: Text('Active')),
                      Tab(child: Text('Complete')),
                      Tab(child: Text('Cancel')),
                    ],
                    labelColor: Color.fromRGBO(13, 94, 249, 1),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color.fromRGBO(13, 94, 249, 1),
                    indicatorWeight: 4.0,
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOrderList('active'),
                      _buildOrderList('complete'),
                      _buildOrderList('cancel'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No orders found.'));
        }

        var orders = snapshot.data!.docs
            .where((order) => order['status'] == status)
            .toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index].data() as Map<String, dynamic>;
            String orderId = orders[index].id;
            double totalPrice = (order['totalPrice']).toDouble();
            List<dynamic> items = order['items'] ?? [];

            return ExpansionTile(
              title: Text(
                'Order ${index + 1}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                  'Items: ${items.length} | Total: \$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              trailing: Text('Date: ${order['date'].toDate()}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              var item =
                              items[itemIndex] as Map<String, dynamic>;
                              return ListTile(
                                leading: Image.network(item['image']),
                                title: Text(item['name'] ?? 'No Name'),
                                subtitle:
                                Text('Quantity: ${item['quantity']}'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (status == 'active') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _trackOrder(orderId),
                            child: Text('Track Order',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: Size(120, 50),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _cancelOrder(orderId),
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.blue)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50),
                            ),
                          ),
                        ],
                      ),
                    ] else if (status == 'cancel') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _reorder(orderId),
                            child: Text('Re-order',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: Size(120, 50),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _deleteOrder(orderId),
                            child: Text('Delete',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.blue)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 50),
                            ),
                          ),
                        ],
                      ),
                    ] else if (status == 'complete') ...[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _leaveReview(orderId),
                              child: Text('Leave Review',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: Size(120, 50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10,)
              ],
            );
          },
        );
      },
    );
  }
}
