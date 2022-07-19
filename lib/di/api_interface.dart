
import '../repository/product_repository.dart';

///
/// This class provides all API related repositories
///
class ApiInterface implements ApiInterfaceService {
  @override
  ProductRepositoryImpl getProductRepositoryImpl() {
    return ProductRepositoryImpl();
  }

}

abstract class ApiInterfaceService {
  ProductRepositoryImpl getProductRepositoryImpl();
}
