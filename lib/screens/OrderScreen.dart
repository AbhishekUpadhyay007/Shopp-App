import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static final routeName = './OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('OrderScreen'),
        ),
        body: FutureBuilder(
            future:
                Provider.of<OrderItems>(context, listen: false).fetchOrders(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (dataSnapshot.error != null) {
                //....
                //...
                return Center(
                  child: Text('An error occured!'),
                );
              } else {
                return Consumer<OrderItems>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) =>
                        SingleOrderItem(orderData.getOrderItems[i]),
                    itemCount: orderData.getOrderItems.length,
                  ),
                );
              }
            }));
  }
}
