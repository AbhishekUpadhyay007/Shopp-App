import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  // final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  final uniqueId;

  CartItem({
    @required this.productId,
    // @required this.imageUrl,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        // margin: EdgeInsets.symmetric(horizontal: 10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure you want to delete?'),
                  content: Text(
                      'Are you sure? Once you delete it you\'ve to again order the stuffs.'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    RaisedButton(textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ));
      },
      onDismissed: (dismiss) {
        Provider.of<Cart>(context, listen: false).removeItems(uniqueId);
      },
      child: ListTile(
        leading: CircleAvatar(
            child: FittedBox(
          child: Text('Rs. $price'),
        )),
        title: Text('Total Rs.${price * quantity}'),
        subtitle: Text('Price Rs.$price'),
        trailing: Text('Quantity: $quantity'),
      ),
    );
  }
}
