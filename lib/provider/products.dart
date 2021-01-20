import 'package:ShopApp/models/HttpException.dart';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken;
  String uId;

  Products(this.authToken, this._items, this.uId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((item) => item.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchdata([bool filter = false]) async {
    final filterUrl= filter ? 'orderBy="creatorId"&equalTo="$uId"' : "";
    var url =
        'https://project-of-corona.firebaseio.com/products.json?auth=$authToken&$filterUrl';

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final List<Product> loadedProducts = [];
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      url = "https://project-of-corona.firebaseio.com/userFavourites/$uId.json?auth=$authToken";
      final favouriteResponse = await http.get(url);
      final favData = json.decode(favouriteResponse.body);
      fetchedData.forEach((prodId, product) {
        loadedProducts.add(Product(
          id: prodId,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: favData[prodId] == null ? false : favData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://project-of-corona.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': false
          }));

      print(json.decode(response.body));
      final addedProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _items.insert(0, addedProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final url =
          'https://project-of-corona.firebaseio.com/products/$productId.json?auth=$authToken';
      final existingIndex =
          _items.indexWhere(((product) => productId == product.id));
      var existingData = _items[existingIndex];

      _items.removeWhere((product) => productId == product.id);
      notifyListeners();
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(existingIndex, existingData);
        notifyListeners();
        throw HttpException('Cannot delete this product!');
      }
      existingData = null;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> updateProduct(String id, Product product) async {
    var index = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://project-of-corona.firebaseio.com/products/$id.json?$authToken';
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }));
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }
}
