import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:practical/model/product.dart';

import '../../di/app_component_base.dart';
import '../common/app_exception.dart';
import '../common/widget/bloc_provider.dart';

class ProductBloc extends BlocBase {
  final _productStreamController = StreamController<List<Product>>();

  Stream<List<Product>> get productStream =>
      _productStreamController.stream;

  final didReachToEndStreamController = StreamController<bool>();
  List<Product> allProducts = [];
  final int itemsLimit = 5;

  @override
  void dispose() {
    _productStreamController.close();
  }

  void fetchProducts(int currentPage) {
    AppComponentBase.getInstance()
        ?.getApiInterface()
        .getProductRepositoryImpl().getProductList(currentPage,itemsLimit)
        .then((products) {
      allProducts.addAll(products.data!);
      _productStreamController.sink.add(allProducts);
      didReachToEndStreamController.add(products.data!.length < itemsLimit);
    }).catchError((error) {
      if (error is AppException) {
        error.onException();
      } else {
        debugPrint(error.toString());
      }
    });
  }
}
