import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practical/di/api_client.dart';

import '../model/product_response.dart';
import '../ui/common/app_exception.dart';

class ProductServices {
  Future<ProductResponse> getProductList(int currentPage, int pageCount) async {
    debugPrint("CurrentPage = $currentPage");
    debugPrint("pageCount = $pageCount");
    try {
      var headers = await ApiClient().getAuthorizedHeader();
      final response = await post(
          Uri.parse(ApiClient.baseUrl + "product_list.php"),
          headers: headers,
          body: jsonEncode(
              <String, int?>{'page': currentPage, 'perPage': pageCount}));
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
