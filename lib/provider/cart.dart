import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int getItemCount() {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingValue) => CartItem(
            id: existingValue.id,
            title: existingValue.title,
            price: existingValue.price,
            quantity: existingValue.quantity + 1),
      );
      print(_items);
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
      print(_items);
    }

    notifyListeners();
  }

  void removeItems(String id) {
    _items.remove(id);
    print(_items);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }

    if (_items[productID].quantity > 1) {
      _items.update(
        productID,
        (product) => CartItem(
            id: product.id,
            price: product.price,
            title: product.title,
            quantity: product.quantity - 1),
      );
    }else{
      _items.remove(productID);
    }
    notifyListeners();
  }
}
