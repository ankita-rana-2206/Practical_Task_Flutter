import 'package:practical/model/product_response.dart';
import 'package:practical/services/product_services.dart';

import '../model/product.dart';
import '../model/response_handler.dart';

class ProductRepositoryImpl extends ProductRepository {
  final _productService = ProductServices();
  @override
  Future<ProductResponse> getProductList() async {
    return await _productService.getProductList();
  }

}

abstract class ProductRepository {
  Future<ProductResponse> getProductList();
}