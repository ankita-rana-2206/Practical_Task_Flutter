
import 'dart:convert';

import 'package:practical/model/product.dart';

ProductResponse welcomeFromJson(String str) => ProductResponse.fromJson(json.decode(str));

String welcomeToJson(ProductResponse data) => json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
    this.status,
    this.message,
    this.totalRecord,
    this.totalPage,
    this.data,
  });

  int? status;
  String? message;
  int? totalRecord;
  int? totalPage;
  List<Product>? data;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    status: json["status"],
    message: json["message"],
    totalRecord: json["totalRecord"],
    totalPage: json["totalPage"],
    data: (json['data'] as List)
        .map((e) => Product.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] =  status;
    data['message'] = message;
    data['totalRecord'] = totalRecord;
    data['totalPage'] =  totalPage;
    data['data'] = this.data?.map((v) => v.toJson()).toList();
    return data;
  }
}