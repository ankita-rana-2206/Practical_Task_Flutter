import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treadsure/di/app_component_base.dart';
import 'package:treadsure/di/db_constants.dart';
import 'package:treadsure/models/payment_history.dart';
import 'package:treadsure/models/tyre_brand.dart';
import 'package:treadsure/models/tyre_condition.dart';
import 'package:treadsure/models/tyre_details.dart';
import 'package:treadsure/models/tyre_model.dart';
import 'package:treadsure/models/tyre_size.dart';

import '../models/tyre_brand.dart';
import '../models/tyre_condition.dart';
import '../models/tyre_size.dart';

class DBHelper {
  static Database database;

  StreamController<String> _syncedIdStreamController =
  StreamController.broadcast();

  Stream<String> get syncedIdStream => _syncedIdStreamController.stream;

  dispose() {
    _syncedIdStreamController.close();
  }

  initialiseDatabase() async {
    openDatabase(
      join(await getDatabasesPath(), 'treadsure.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS ${DBConstants.tyreDetailTable} '
              '(${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT, '
              '${DBConstants.timeStamp} VARCHAR, '
              '${DBConstants.tyreDetails} VARCHAR)',
        );
        db.execute('CREATE TABLE IF NOT EXISTS ${DBConstants.brandTable} '
            '(${DBConstants.brands} VARCHAR)');
        db.execute('CREATE TABLE IF NOT EXISTS ${DBConstants.historyTable} '
            '(${DBConstants.histories} VARCHAR)');
        db.execute('CREATE TABLE IF NOT EXISTS ${DBConstants.modelTable} '
            '(${DBConstants.models} VARCHAR)');
        db.execute('CREATE TABLE IF NOT EXISTS ${DBConstants.sizeTable} '
            '(${DBConstants.size} VARCHAR)');
        db.execute('CREATE TABLE IF NOT EXISTS ${DBConstants.conditionTable} '
            '(${DBConstants.condition} VARCHAR)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS ${DBConstants.selectedBrandTable} '
                '(${DBConstants.brandId} INTEGER,'
                '${DBConstants.selectedBrands} VARCHAR)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS ${DBConstants.selectedModelTable} '
                '(${DBConstants.modelId} INTEGER,'
                '${DBConstants.selectedModel} VARCHAR)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS ${DBConstants.selectedSizeTable} '
                '(${DBConstants.sizeId} INTEGER,'
                '${DBConstants.selectedSize} VARCHAR)');
      },
      version: 1,
    ).then((value) => database = value);
  }

  Future<int> insertTyreDetail(
      TyreDetails tyreDetails, String timeStamp) async {
    if (tyreDetails.images != null && tyreDetails.images.length > 0) {
      tyreDetails = await _convertImages(tyreDetails);
    }
    var data = Map<String, String>();
    data[DBConstants.timeStamp] = timeStamp;
    data[DBConstants.tyreDetails] = jsonEncode(tyreDetails);
    return await database.insert(
      DBConstants.tyreDetailTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Map<String, List<TyreDetails>>> getTyreDetails(
      {String timeStamp}) async {
    var data = await database.query(DBConstants.tyreDetailTable,
        where: timeStamp != null ? "${DBConstants.timeStamp} =? " : null,
        whereArgs: timeStamp != null ? [timeStamp] : null);
    Map<String, List<TyreDetails>> listOfData = Map();
    await Future.forEach(data, ((value) async {
      if (listOfData.containsKey(value[DBConstants.timeStamp])) {
        var list = listOfData[value[DBConstants.timeStamp]];
        TyreDetails tyreDetails =
        TyreDetails.fromJson(jsonDecode(value[DBConstants.tyreDetails]));
        if (tyreDetails.imageStrings != null &&
            tyreDetails.imageStrings.length > 0) {
          tyreDetails = await _getImagesFromDb(tyreDetails);
        }
        list.add(tyreDetails);
        listOfData[value[DBConstants.timeStamp]] = list;
      } else {
        var list = List<TyreDetails>();
        TyreDetails tyreDetails =
        TyreDetails.fromJson(jsonDecode(value[DBConstants.tyreDetails]));
        if (tyreDetails.imageStrings != null &&
            tyreDetails.imageStrings.length > 0) {
          tyreDetails = await _getImagesFromDb(tyreDetails);
        }
        list.add(tyreDetails);
        listOfData[value[DBConstants.timeStamp]] = list;
      }
    }));
    return listOfData;
  }

  Future<int> removeTyreDetails(String timeStamp) {
    return database.delete(DBConstants.tyreDetailTable,
        where: '${DBConstants.timeStamp} =? ', whereArgs: [timeStamp]);
  }

  Future<int> insertBrands(List<TyreBrand> tyreBrands) async {
    database.delete(DBConstants.brandTable);
    Map<String, String> data = Map();
    data[DBConstants.brands] = jsonEncode(tyreBrands);
    return await database.insert(
      DBConstants.brandTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertHistory(List<PaymentHistory> histories) async {
    database.delete(DBConstants.historyTable);
    Map<String, String> data = Map();
    data[DBConstants.histories] = jsonEncode(histories);
    return await database.insert(
      DBConstants.historyTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSelectedBrands(TyreBrand tyreBrands) async {
    Map<String, String> data = Map();
    data[DBConstants.selectedBrands] = jsonEncode(tyreBrands);
    data[DBConstants.brandId] = tyreBrands.id.toString();
    print("data = $data");
    return await database.insert(
      DBConstants.selectedBrandTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertModels(List<TyreModel> tyreModels) async {
    database.delete(DBConstants.modelTable);
    Map<String, String> data = Map();
    data[DBConstants.models] = jsonEncode(tyreModels);
    return await database.insert(
      DBConstants.modelTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSelectedModel(TyreModel tyreModel) async {
    Map<String, String> data = Map();
    data[DBConstants.selectedModel] = jsonEncode(tyreModel);
    data[DBConstants.modelId] = tyreModel.id.toString();
    return await database.insert(
      DBConstants.selectedModelTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSize(List<TyreSize> tyreSize) async {
    database.delete(DBConstants.sizeTable);
    Map<String, String> data = Map();
    data[DBConstants.size] = jsonEncode(tyreSize);
    return await database.insert(
      DBConstants.sizeTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSelectedSize(TyreSize tyreSize) async {
    Map<String, String> data = Map();
    data[DBConstants.selectedSize] = jsonEncode(tyreSize);
    data[DBConstants.sizeId] = tyreSize.id.toString();
    return await database.insert(
      DBConstants.selectedSizeTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSelectedSizeName(String tyreSize) async {
    Map<String, String> data = Map();
    data[DBConstants.selectedSize] = jsonEncode(tyreSize);
    return await database.insert(
      DBConstants.selectedSizeTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertCondition(List<TyreCondition> tyreCondition) async {
    database.delete(DBConstants.conditionTable);
    Map<String, String> data = Map();
    data[DBConstants.condition] = jsonEncode(tyreCondition);
    return await database.insert(
      DBConstants.conditionTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PaymentHistory>> getAllHistory() async {
    var data = await database
        .query(DBConstants.historyTable, columns: [DBConstants.histories]);
    print("data = $data");
    if (data.length > 0) {
      String brands = data[0].values.toList()[0];
      final values = json.decode(brands);
      final list = List<PaymentHistory>();
      if (values is List) {
        values.forEach((m) {
          list.add(PaymentHistory.fromJson(m));
        });
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<TyreBrand>> getAllTyreBrands() async {
    var data = await database
        .query(DBConstants.brandTable, columns: [DBConstants.brands]);
    if (data.length > 0) {
      String brands = data[0].values.toList()[0];
      final values = json.decode(brands);
      final list = List<TyreBrand>();
      if (values is List) {
        values.forEach((m) {
          list.add(TyreBrand.fromJson(m));
        });
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<TyreBrand>> getAllSelectedTyreBrands() async {
    final list = List<TyreBrand>();
    var data = await database.query(DBConstants.selectedBrandTable,
        distinct: true,
        columns: [DBConstants.selectedBrands, DBConstants.brandId]);
    if (data.length > 0) {
      String brands;
      for (int i = data.length - 1; i >= 0; i--) {
        if (list.length != 3) {
          brands = data[i].values.toList()[0].toString();
          final values = json.decode(brands);
          list.add(TyreBrand.fromJson(values));
        } else {
          brands = data[i].values.toList()[0].toString();
          final values = json.decode(brands);
          database.rawDelete(
              'DELETE FROM ${DBConstants.selectedBrandTable} WHERE ${DBConstants.brandId} = ${values['id']}');
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<TyreModel>> getAllSelectedTyreModel(int brandId) async {
    final list = List<TyreModel>();
    var data = await database.query(DBConstants.selectedModelTable,
        distinct: true, columns: [DBConstants.selectedModel]);
    if (data.length > 0) {
      String models;
      for (int i = data.length - 1; i >= 0; i--) {
        if (list.length != 3) {
          models = data[i].values.toList()[0];
          final values = json.decode(models);
          var tyreModel = TyreModel.fromJson(values);
          if (tyreModel.brandId == brandId) {
            list.add(tyreModel);
          }
        } else {
          models = data[i].values.toList()[0];
          final values = json.decode(models);
          var tyreModel = TyreModel.fromJson(values);
          if (tyreModel.brandId == brandId) {
            database.rawDelete(
                'DELETE FROM ${DBConstants.selectedModelTable} WHERE ${DBConstants.modelId} = ${values['id']}');
          }
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<TyreSize>> getAllSelectedTyreSize(
      int brandId, int modelId) async {
    final list = List<TyreSize>();
    var data = await database.query(DBConstants.selectedSizeTable,
        distinct: true, columns: [DBConstants.selectedSize]);
    if (data.length > 0) {
      String size;
      for (int i = data.length -1; i >= 0; i--) {
        if (list.length != 3) {
          size = data[i].values.toList()[0];
          final values = json.decode(size);
          var tyreSize = TyreSize.fromJson(values);

          if (tyreSize.brandId != null &&
              tyreSize.brandModelId != null &&
              tyreSize.brandId == brandId &&
              tyreSize.brandModelId == modelId) {
            list.add(tyreSize);
          }
        } else {
          size = data[i].values.toList()[0];
          final values = json.decode(size);
          var tyreSize = TyreSize.fromJson(values);
          if (tyreSize.brandId != null &&
              tyreSize.brandModelId != null &&
              tyreSize.brandId == brandId &&
              tyreSize.brandModelId == modelId) {
            database.rawDelete(
                'DELETE FROM ${DBConstants.selectedModelTable} WHERE ${DBConstants.sizeId} = ${values['id']}');
          }
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<TyreModel>> getAllTyreModelsByBrandId(int brandId) async {
    var data = await database
        .query(DBConstants.modelTable, columns: [DBConstants.models]);
    if (data.length > 0) {
      String models = data[0].values.toList()[0];
      final values = json.decode(models);
      final tyreModels = List<TyreModel>();
      if (values is List) {
        values.forEach((m) {
          var tyreModel = TyreModel.fromJson(m);
          if (tyreModel.brandId == brandId) {
            tyreModels.add(tyreModel);
          }
        });
      }
      return tyreModels;
    } else {
      return [];
    }
  }

  Future<List<TyreSize>> getAllTyreSize(int brandId, int modelId) async {
    var data = await database
        .query(DBConstants.sizeTable, columns: [DBConstants.size]);
    if (data.length > 0) {
      String sizes = data[0].values.toList()[0];
      final values = json.decode(sizes);
      final tyreSizes = List<TyreSize>();
      if (values is List) {
        values.forEach((m) {
          var tyreSize = TyreSize.fromJson(m);
          if (tyreSize.brandId != null &&
              tyreSize.brandModelId != null &&
              tyreSize.brandId == brandId &&
              tyreSize.brandModelId == modelId) {
            tyreSizes.add(tyreSize);
          }
        });
      }
      return tyreSizes;
    } else {
      return [];
    }
  }

  Future<List<TyreCondition>> getAllTyreConditions() async {
    var data = await database
        .query(DBConstants.conditionTable, columns: [DBConstants.condition]);
    if (data.length > 0) {
      String conditions = data[0].values.toList()[0];
      final values = json.decode(conditions);
      final list = List<TyreCondition>();
      if (values is List) {
        values.forEach((element) {
          list.add(TyreCondition.fromJson(element));
        });
      }
      return list;
    } else {
      var tyreCondition = List<TyreCondition>();
      tyreCondition.add(TyreCondition(name: "Poor"));
      tyreCondition.add(TyreCondition(name: "Fair"));
      tyreCondition.add(TyreCondition(name: "Good"));
      tyreCondition.add(TyreCondition(name: "Excellent"));
      return tyreCondition;
    }
  }

  _convertImages(TyreDetails tyreDetails) async {
    List<String> images = List();
    await Future.forEach(tyreDetails.images, (element) async {
      final bytes = await testCompressFile(element);
      images.add(base64Encode(bytes));
    });
    tyreDetails.imageStrings = images;
    tyreDetails.images.clear();
    return tyreDetails;
  }

  Future<TyreDetails> _getImagesFromDb(TyreDetails tyreDetails) async {
    List<File> images = List();
    await Future.forEach(tyreDetails.imageStrings, (element) async {
      final bytes = base64Decode(element);
      String path = (await getTemporaryDirectory()).path;
      var file = File(
          path + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
      file.writeAsBytesSync(bytes);
      images.add(file);
    });
    tyreDetails.images = images;
    tyreDetails.imageStrings.clear();
    return tyreDetails;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  String base64Encode(List<int> bytes) => base64.encode(bytes);

  Uint8List base64Decode(String source) => base64.decode(source);

  Future<List<int>> testCompressFile(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
      rotate: 0,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  Future<void> syncDataWithServer() async {
    var data = await getTyreDetails();
    int i = 0;
    await Future.forEach(data.values, (element) async {
      if (element is List<TyreDetails>) {
        try {
          var tyreDetails = await AppComponentBase.getInstance()
              .getApiInterface()
              .getTyreRepository()
              .addTyres(element);
          await _uploadImages(element, tyreDetails);
          removeTyreDetails(data.keys.toList()[i]);
        } catch (error) {
          print("Sync Error");
        }
      }
      i += 1;
    });
  }

  Future<void> syncDataWithServerById(String id) async {
    var data = await getTyreDetails(timeStamp: id);
    int i = 0;
    await Future.forEach(data.values, (element) async {
      if (element is List<TyreDetails>) {
        try {
          var tyreDetails = await AppComponentBase.getInstance()
              .getApiInterface()
              .getTyreRepository()
              .addTyres(element);
          await _uploadImages(element, tyreDetails);
          removeTyreDetails(data.keys.toList()[i]);
          _syncedIdStreamController.sink.add(id);
        } catch (error) {
          print("Sync Error");
        }
      }
      i += 1;
    });
  }

  _uploadImages(List<TyreDetails> tyreDetails,
      List<TyreDetails> responseTyreDetails) async {
    if (tyreDetails.length == responseTyreDetails.length) {
      int i = 0;
      await Future.forEach(tyreDetails, (tyreDetail) async {
        final detail = responseTyreDetails[i];
        if (tyreDetail is TyreDetails &&
            tyreDetail.images != null &&
            tyreDetail.images.length > 0) {
          await AppComponentBase.getInstance()
              .getApiInterface()
              .getTyreRepository()
              .uploadImages(detail.id, tyreDetail.images)
              .then((value) {
            print("success image upload: " + value.toString());
          }).catchError((error) {
            print(error.toString());
          });
        }
        if (tyreDetail is TyreDetails) {
          tyreDetail.id = detail.id;
          tyreDetail.createdAt = detail.createdAt;
          tyreDetail.updatedAt = detail.updatedAt;
          tyreDetail.deletedAt = detail.deletedAt;
        }
        i += 1;
      });
      await AppComponentBase.getInstance()
          .getApiInterface()
          .getTyreRepository()
          .sendEmail(tyreDetails)
          .then((value) {
        if (value) {
          print("Email Synced");
        }
      }).catchError((error) {
        print("Email sync failed");
      });
    }
  }
}
