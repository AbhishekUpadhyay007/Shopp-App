import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart' as ci;
import '../widgets/cart_item.dart';
import '../screens/OrderScreen.dart';
import '../provider/Orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ci.Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text('Rs. ${cart.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color)),
                  ),
                  ButtonWidget(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                // imageUrl: product.items[i].imageUrl,
                title: cart.items.values.toList()[i].title,
                productId: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                uniqueId: cart.items.keys.toList()[i],
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final ci.Cart cart;

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;

    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrderItems>(context, listen: false).addOrders(
                    widget.cart.items.values.toList(), widget.cart.totalAmount, );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              } catch (error) {
                print(error);
              }
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
