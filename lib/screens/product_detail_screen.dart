import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = './ProductDetails';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(loadedProduct.title),
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 20),
            Text(
              loadedProduct.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Price: Rs. ${loadedProduct.price}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
             Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 1000),
          ]))
        ],
      ),
    );
  }
}
