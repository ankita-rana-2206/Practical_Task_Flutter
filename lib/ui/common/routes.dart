

import 'package:flutter/material.dart';

import '../product_listing/product_page.dart';

class RouteName {
  static const String root = "/";
  static const String shoppingMall = "/product_page";
}

class Routes {
  static final baseRoutes = <String, WidgetBuilder>{
    RouteName.root: (context) => const ProductPage(),
  };
}

