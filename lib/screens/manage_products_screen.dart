import 'package:flutter/material.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';
import '../widgets/shop_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_product_screen.dart';

class ManageProducts extends StatelessWidget {
  static const routeName = './ManageProducts';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchdata(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            itemBuilder: (ctx, i) => ShopItem(
                                productData.items[i].id,
                                productData.items[i].imageUrl,
                                productData.items[i].title),
                            itemCount: productData.items.length),
                      ),
                    ),
                  ),
      ),
    );
  }
}
