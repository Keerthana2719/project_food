import 'package:get/get.dart';

class CartController extends GetxController {
  // Observable state variables
  var cartItems = <Map<String, dynamic>>[].obs;

  // Method to add an item to the cart
  void addToCart(Map<String, dynamic> item) {
    // Check if the item already exists in the cart
    final existingItem = cartItems.firstWhere(
          (cartItem) => cartItem['name'] == item['name'],
      orElse: () => {},
    );

    if (existingItem.isNotEmpty) {
      // Item exists, increase quantity
      existingItem['quantity'] = (existingItem['quantity'] ?? 0) + 1;
    } else {
      // Item does not exist, add to cart
      item['quantity'] = 1;
      cartItems.add(item);
    }
  }

  // Method to remove an item from the cart
  void removeFromCart(Map<String, dynamic> item) {
    cartItems.remove(item);
  }
}
