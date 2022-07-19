import 'dart:convert';

import '../di/api_client.dart';

class ResponseHandler<T> {
  ResponseHandler({
    this.error,
    this.status,
    this.message,
    this.response,
  });

  bool? error;
  int? status;
  String? message;
  Object? response;

  factory ResponseHandler.fromRawJson(String str) => ResponseHandler.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseHandler.fromJson(Map<String, dynamic> json) => ResponseHandler(
    error: json["error"] == null
        ? null
        : json["error"] is bool
        ? json["error"]
        : json["error"].toLowerCase() == 'true',
    status: json["status"],
    message: json["error"] != null
        ? (json["error"] is bool ? json["error"] : json["error"].toLowerCase() == 'true')
        ? (json["result"] == null
        ? json["message"]
        : (((json["result"] as Map<String, dynamic>)[json["response"].keys.elementAt(0)] is List
        ? (((json["result"] as Map<String, dynamic>)[json["response"].keys.elementAt(0)] as List)[0]
        .toString())
        : "")))
        : json["message"]
        : json["message"],
    response: json["error"] == null || json["response"] == null
        ? null
        : (json["error"] is bool ? json["error"] : json["error"].toLowerCase() == 'true')
        ? null
        : ApiClient.convertMapToObject<T>(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "status": status,
    "message": message,
    "response": response,
  };

  bool hasError() {
    return status != 200;
  }

  Y? getResult<Y>() {
    return response as Y;
  }
}