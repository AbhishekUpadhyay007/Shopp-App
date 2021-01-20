import 'package:flutter/material.dart';
import '../widgets/grid_products.dart';
import '../widgets/badge.dart';

import 'package:provider/provider.dart';
import '../provider/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../provider/products.dart';
import 'package:http/http.dart';

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

enum FilterProducts { Favorite, All }

class _ProductOverviewState extends State<ProductOverview> {
  var _selectedFilter = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(_isInit){
      setState(() {
        _isLoading = true;  
      });
       Provider.of<Products>(context).fetchdata().then((_){
          setState(() {
            _isLoading = false;
          });
       });
    }
    _isInit = false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.getItemCount().toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterProducts filter) {
              setState(() {
                print(filter);
                if (filter == FilterProducts.Favorite) {
                  _selectedFilter = true;
                } else {
                  _selectedFilter = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FilterProducts.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterProducts.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsInGrid(_selectedFilter),
    );
  }
}
