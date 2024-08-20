import 'package:flutter/material.dart';
import 'package:project_food/screen/payment.dart';

class Add extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final double basketTotal;

  const Add({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
    required this.basketTotal,
  }) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  String selectedLocation = "Home"; // Default selected location

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.totalPrice;
    double discount = 10; // Example discount
    double basketTotal = widget.basketTotal;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
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
                      "Deliver to",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 10,),
                    buildLocationTile(
                      "Home",
                      "assets/loc.png",
                      "Artur Liste St.109",
                    ),
                    SizedBox(height: 20),
                    buildLocationTile(
                      "Office",
                      "assets/loc.png",
                      "Artur Liste St.109",
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Container(
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
                            "+ AED ${totalPrice.toStringAsFixed(2)}",
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
                            "- AED ${discount.toStringAsFixed(2)}",
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
                            "AED ${basketTotal.toStringAsFixed(2)}",
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
                SizedBox(height: 23),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(
                          cartItems: widget.cartItems,
                          totalPrice: widget.totalPrice,
                          basketTotal: widget.basketTotal,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 70,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(0, 7),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
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
    );
  }

  Widget buildLocationTile(String location, String iconPath, String address) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLocation = location;
        });
      },
      child: Container(
        width: double.infinity,
        height: 102,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedLocation == location
                ? Color.fromRGBO(13, 94, 249, 0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25,),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
