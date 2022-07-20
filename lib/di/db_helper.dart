import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:practical/model/product.dart';
import 'package:sqflite/sqflite.dart';

import '../ui/common/dbConstant.dart';

class DBHelper {
  late Database database;

  final StreamController<String> _syncedIdStreamController =
      StreamController.broadcast();

  Stream<String> get syncedIdStream => _syncedIdStreamController.stream;

  dispose() {
    _syncedIdStreamController.close();
  }

  initialiseDatabase() async {
    openDatabase(
      join(await getDatabasesPath(), 'practical.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS ${DBConstants.cartDetailTable} '
          '(${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${DBConstants.timeStamp} VARCHAR, '
          '${DBConstants.cartDetail} VARCHAR)',
        );
      },
      version: 1,
    ).then((value) => database = value);
  }

  Future<int> insertCartDetails(Product cartDetail) async {
    // if (tyreDetails.images != null && tyreDetails.images.length > 0) {
    //   tyreDetails = await _convertImages(tyreDetails);
    // }
    var data = <String, String>{};
    data[DBConstants.cartDetail] = jsonEncode(cartDetail);
    return await database.insert(
      DBConstants.cartDetailTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Product>> getCartItems() async {
    var data = await database.query(DBConstants.cartDetailTable);
    final list = <Product>[];
    for (int i = 0; i < data.length; i++) {
      String product = data[i].values.toList()[2].toString();
      debugPrint("product_String, $product");
      final values = json.decode(product);
      debugPrint("product_String, $values");
      list.add(Product.fromJson(values));
    }
    debugPrint("List = ${list.length}");
    return list;
  }
//
// Future<int> removeTyreDetails(String timeStamp) {
//   return database.delete(DBConstants.tyreDetailTable,
//       where: '${DBConstants.timeStamp} =? ', whereArgs: [timeStamp]);
// }
}
