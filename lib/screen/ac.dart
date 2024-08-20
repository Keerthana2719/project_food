import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_food/screen/payment.dart';

class Ac extends StatefulWidget {
  const Ac({super.key});

  @override
  State<Ac> createState() => _AcState();
}

class _AcState extends State<Ac> {
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  get totalprice => null;

  get baskettotal => null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                          )
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
                    "Add Card",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Curved corners for the image
                  child: Image.asset(
                    "assets/card.png",
                    width: 263,
                    height: 155,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 50),
              _buildTextField("CARD HOLDER NAME", "Vishal Khadok", _cardHolderNameController),
              SizedBox(height: 20),
              _buildTextField("CARD NUMBER", "_ _ _ _ _ _ _ _ _ _ _", _cardNumberController),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("EXPIRE DATE", "mm/yyyy", _expireDateController),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField("CVC", "* * *", _cvcController),
                  ),
                ],
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  _addCardToFirestore();
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
                        "ADD CARD  +",
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
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 61,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromRGBO(240, 245, 250, 1),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addCardToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('card').add({
        'cardHolderName': _cardHolderNameController.text,
        'cardNumber': _cardNumberController.text,
        'expireDate': _expireDateController.text,
        'cvc': _cvcController.text,
      });
      // Navigate to payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(cartItems: [], totalPrice: totalprice, basketTotal: baskettotal,),
        ),
      );
    } catch (e) {
      // Handle errors here
      print('Error adding card: $e');
    }
  }
}
