import 'package:ShopApp/screens/16.1%20splash_screen.dart';

import './provider/auth.dart';
import './screens/4.1%20auth_screen.dart';

import './provider/products.dart';
import 'package:flutter/material.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import './screens/OrderScreen.dart';

import './provider/cart.dart';
import './provider/Orders.dart';
import './screens/cart_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/add_product_screen.dart';
import './screens/product_overview_screen.dart';
import './helpers/CustomRoute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previous) => Products(auth.token,
                previous == null ? [] : previous.items, auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, OrderItems>(
            update: (ctx, auth, previous) => OrderItems(auth.token,
                previous == null ? [] : previous.getOrderItems, auth.userId),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'Lato',
              accentTextTheme:
                  TextTheme(headline6: TextStyle(color: Colors.white)),
              primarySwatch: Colors.teal,
              accentColor: Colors.orange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android : CustomTransitionBuilder(),
                TargetPlatform.iOS : CustomTransitionBuilder(),
              })
            ),
            home: authData.isAuth
                ? ProductOverview()
                : FutureBuilder(
                    future: authData.tryLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetail.routeName: (ctx) => ProductDetail(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              ManageProducts.routeName: (ctx) => ManageProducts(),
              AddProductScreen.routeName: (ctx) => AddProductScreen()
            },
          ),
        ));
  }
}
