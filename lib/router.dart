import 'package:amazon/app.dart';
import 'package:amazon/features/account/models/order_model.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/home/screens/category.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/features/order%20details/screens/order_details.dart';
import 'package:amazon/features/product%20details/screens/product_details.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/shared/widgets/bottomnav.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings setting) {
  switch (setting.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (context) => const AuthScreen());

    case Home.routeName:
      return MaterialPageRoute(builder: (context) => Home());

    case BottomNavBar.routeName:
      return MaterialPageRoute(builder: (context) => const BottomNavBar());

    case Decider.routeName:
      return MaterialPageRoute(builder: (context) => const Decider());
    case AddProduct.routeName:
      return MaterialPageRoute(builder: (context) => const AddProduct());
    case CategoryScreen.routeName:
      var title = setting.arguments as String;
      return MaterialPageRoute(
          settings: setting,
          builder: (context) => CategoryScreen(title: title));
    case SearchScreen.routeName:
      var searchQuery = setting.arguments as String;
      return MaterialPageRoute(
          settings: setting,
          builder: (context) => SearchScreen(searchQuery: searchQuery));
    case ProductDetail.routeName:
      var product = setting.arguments as Product;
      return MaterialPageRoute(
          settings: setting,
          builder: (context) => ProductDetail(product: product));
    case OrderDetails.routeName:
      var order = setting.arguments as Order;
      return MaterialPageRoute(
          settings: setting, builder: (context) => OrderDetails(order: order));

    default:
      return MaterialPageRoute(
        settings: setting,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
