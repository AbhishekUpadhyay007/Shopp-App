import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../screens/add_product_screen.dart';

class ShopItem extends StatelessWidget {
  final String id;
  final String imgUrl;
  final String title;

  ShopItem(this.id, this.imgUrl, this.title);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: Container(
        child: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              )),
          IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeItem(id);
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Item deleted successfully!',
                      textAlign: TextAlign.center,
                    ),
                  ));
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Cannot delete Item',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ))
        ]),
      ),
    );
  }
}
