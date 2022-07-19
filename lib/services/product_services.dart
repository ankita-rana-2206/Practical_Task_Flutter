import 'dart:convert';

import 'package:http/http.dart';
import 'package:practical/di/api_client.dart';

import '../model/product_response.dart';
import '../ui/common/app_exception.dart';

class ProductServices {
  Future<ProductResponse> getProductList() async {
    try {
      final response =
          await get(Uri.parse(ApiClient.baseUrl + "product_list.php"));
      var responseStatus = ProductResponse.fromJson(json.decode(response.body));
      if (response.statusCode == ApiClient.successResponse &&
          responseStatus.status == ApiClient.successResponse) {
        return responseStatus;
      } else {
        throw CustomException(responseStatus.message ?? '');
      }
    } catch (exception) {
      rethrow;
    }
  }
}
