import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orders {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  Orders({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.dateTime,
  });
}

class OrderItems with ChangeNotifier {
  List<Orders> _orderItems = [];

  String authToken;
  String userId;

  OrderItems(this.authToken, this._orderItems, this.userId);

  List<Orders> get getOrderItems {
    return [..._orderItems];
  }

  Future<void> addOrders(List<CartItem> orders, double total) async {
    final url = 'https://project-of-corona.firebaseio.com/orders/$userId.json?auth=$authToken';
    final date = DateTime.now();
    try {
      await http.post(url,
          body: json.encode({
            'total': total,
            'Date': date.toString(),
            'products': orders
                .map((product) => {
                      'id': date.toString(),
                      'title': product.title,
                      'price': product.price,
                      'quantity': product.quantity,
                    })
                .toList(),
          }));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchOrders() async {
    final url = 'https://project-of-corona.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final fetchedOrders = json.decode(response.body) as Map<String, dynamic>;
      if(fetchedOrders == null){
        return;
      }
      List<Orders> loadedProducts = [];
      print(json.decode(response.body));

      fetchedOrders.forEach((key, orderItem) {
        List<dynamic> _list = orderItem['products'];
        loadedProducts.add(Orders(
          dateTime: DateTime.parse(orderItem['Date']),
          id: key,
          total: orderItem['total'],
          products: _list
              .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList(),
        ));
      });
      _orderItems = loadedProducts.reversed.toList();
      print(_orderItems);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
