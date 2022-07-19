import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'api_interface.dart';
import 'network_manager.dart';

class AppComponentBase extends AppComponentBaseRepository {
  static AppComponentBase? _instance;
  final NetworkManager _networkManager = NetworkManager();
  final ApiInterface _apiInterface = ApiInterface();
  final StreamController<bool> _progressDialogStreamController =
  StreamController.broadcast();

  Stream<bool> get progressDialogStream =>
      _progressDialogStreamController.stream;

  static AppComponentBase? getInstance() {
    _instance ??= AppComponentBase();
    return _instance;
  }

  initialiseNetworkManager() async {
    await _networkManager.initialiseNetworkManager();
  }

  shoProgressDialog(bool value) {
    _progressDialogStreamController.sink.add(value);
  }

  dispose() {
    _progressDialogStreamController.close();
  }

  @override
  ApiInterface getApiInterface() {
    return _apiInterface;
  }

  @override
  NetworkManager getNetworkManager() {
    return _networkManager;
  }
}

abstract class AppComponentBaseRepository {
  ApiInterface getApiInterface();

  //SharedPreference getSharedPreference();

  NetworkManager getNetworkManager();
}
