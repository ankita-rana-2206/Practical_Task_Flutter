import 'package:practical/model/product.dart';

///
/// This class contains all URL which is being called to fetch data from server
///
class ApiClient {
  static String baseUrl = "http://205.134.254.135/~mobile/MtProject/public/api/";
  static const int successResponse = 200;

  static convertMapToObject<T>(val) {
    if (val is List) {
      final list = <T>[];
      val.forEach((element) {
        list.add(getValue<T>(element));
      });
      return list;
    } else {
      return getValue<T>(val);
    }
  }

  static getValue<T>(value) {
    switch (T) {
      case Product:
        return Product.fromJson(value);
      default:
        return value;
    }
  }
}
