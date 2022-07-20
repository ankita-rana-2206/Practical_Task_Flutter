import 'dart:async';

import 'package:practical/di/app_component_base.dart';
import 'package:practical/model/product.dart';
import 'package:practical/ui/common/widget/bloc_provider.dart';

class CartBloc extends BlocBase {
  final cartProductStreamController = StreamController<List<Product>>();

  Stream<List<Product>> get cartProductStream =>
      cartProductStreamController.stream;

  getCartItem() {
    AppComponentBase.getInstance()?.getDbHelper().getCartItems().then((value) {
      cartProductStreamController.sink.add(value);
    });
  }

  @override
  void dispose() {
    cartProductStreamController.close();
  }
}
