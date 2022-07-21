import 'package:practical/model/product_response.dart';
import 'package:practical/services/product_services.dart';

class ProductRepositoryImpl extends ProductRepository {
  final _productService = ProductServices();
  @override
  Future<ProductResponse> getProductList(int currentPage, int pageCount) async {
    return await _productService.getProductList(currentPage, pageCount);
  }

}

abstract class ProductRepository {
  Future<ProductResponse> getProductList(int currentPage, int pageCount);
}