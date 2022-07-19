import 'dart:async';

import 'package:practical/model/product.dart';

import '../../di/app_component_base.dart';
import '../common/app_exception.dart';
import '../common/widget/bloc_provider.dart';

class ProductBloc extends BlocBase {
  final _productStreamController = StreamController<List<Product>>();

  Stream<List<Product>> get productStream =>
      _productStreamController.stream;

  @override
  void dispose() {
    _productStreamController.close();
  }

  void fetchProducts() {
    AppComponentBase.getInstance()
        ?.getApiInterface()
        .getProductRepositoryImpl().getProductList()
        .then((products) {
      _productStreamController.sink.add(products.data!);
    }).catchError((error) {
      if (error is AppException) {
        error.onException();
      } else {
        print(error.toString());
      }
    });
  }
}
