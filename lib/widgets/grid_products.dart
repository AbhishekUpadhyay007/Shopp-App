import 'package:ShopApp/provider/products.dart';
import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductsInGrid extends StatelessWidget {

  final bool selectedFilter;

  ProductsInGrid(this.selectedFilter);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = selectedFilter ? productData.favorites : productData.items;
    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
          // products[index].id,
          // products[index].imageUrl,
          // products[index].title,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
