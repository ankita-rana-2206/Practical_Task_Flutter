import 'dart:async';

import 'package:practical/di/app_component_base.dart';
import 'package:practical/ui/common/widget/bloc_provider.dart';

import '../../model/cart.dart';

class CartBloc extends BlocBase {
  final cartProductStreamController = StreamController<List<Cart>>();

  Stream<List<Cart>> get cartProductStream =>
      cartProductStreamController.stream;

  final totalPriceStreamController = StreamController<int>();

  Stream<int> get totalPriceStream =>
      totalPriceStreamController.stream;

  List<Cart> listCart = [];

  int totalPrice = 0;
  int? singleProductPrice;

  getCartItem() {
    AppComponentBase.getInstance()?.getDbHelper().getCartItems().then((value) {
      listCart.addAll(value);
      cartProductStreamController.sink.add(listCart);
      getTotalAmount();
    });
  }

  @override
  void dispose() {
    cartProductStreamController.close();
  }

  getTotalAmount() {
    for (int i = 0; i< listCart.length; i++) {
      singleProductPrice = ((listCart[i].product?.price!)! * int.parse(listCart[i].productQuantity!));
      singleProductPrice = singleProductPrice! + singleProductPrice!;
    }
    totalPriceStreamController.sink.add(singleProductPrice!);
  }
}
