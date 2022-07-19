import 'package:flutter/material.dart';

abstract class AppException implements Exception {
  void onException({BuildContext? context, Function? onButtonClick});
}

class NoInternetException extends AppException {
  @override
  void onException({BuildContext? context, Function? onButtonClick}) {
    debugPrint("Please check your Internet Connection");
  }
}

class CustomException extends AppException {
  String exception;

  CustomException(this.exception);

  @override
  void onException({BuildContext? context, Function? onButtonClick}) {
    debugPrint(exception);
  }
}

