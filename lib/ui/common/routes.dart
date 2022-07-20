

import 'package:flutter/material.dart';
import 'package:practical/ui/cart/cart_page.dart';

import '../product_listing/product_page.dart';

class RouteName {
  static const String root = "/";
  static const String cartPage = "/cart_page";
}

class Routes {
  static final baseRoutes = <String, WidgetBuilder>{
    RouteName.root: (context) => const ProductPage(),
    RouteName.cartPage: (context) => const CartPage(),
  };
}

