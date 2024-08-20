import 'package:flutter/material.dart';

class Provide extends ChangeNotifier {
  List<Map<String, dynamic>> favorites = [];

  bool toggleFavorite(String name, String sub, String price, String image) {
    // Check if the item is already in favorites
    final isExist = favorites.any((fav) => fav['name'] == name);

    if (isExist) {
      // Remove from favorites
      favorites.removeWhere((fav) => fav['name'] == name);
    } else {
      // Add to favorites
      favorites.add({
        'name': name,
        'sub': sub,
        'price': price,
        'image': image,
      });
    }

    // Notify listeners (assuming this class is a ChangeNotifier)
    notifyListeners();

    // Return true if item is now a favorite, false if removed from favorites
    return !isExist;
  }

  bool isFavorite(String name) {
    return favorites.any((fav) => fav['name'] == name);
  }
}

