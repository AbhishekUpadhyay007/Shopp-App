import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setBool(bool favStatus) {
    isFavorite = favStatus;
    notifyListeners();
  }

  Future<void> toggleFavourite(String token, String uId) async {
    final favStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url =
          "https://project-of-corona.firebaseio.com/userFavourites/$uId/$id.json?auth=$token";
      final response = await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode > 400) {
        _setBool(favStatus);
      }
    } catch (error) {
      _setBool(favStatus);
    }
  }
}
