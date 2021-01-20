import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/OrderScreen.dart';
import '../screens/manage_products_screen.dart';
import '../helpers/CustomRoute.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Hello user!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 26),
              ),
              backgroundColor: Colors.white),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text(
              'Products',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrderScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              'Manage Orders',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ManageProducts.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Log out!',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(ManageProducts.routeName);
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
