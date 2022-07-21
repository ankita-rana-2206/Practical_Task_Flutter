import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:practical/model/product.dart';
import 'package:sqflite/sqflite.dart';

import '../model/cart.dart';
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
          '${DBConstants.productId} INTEGER, '
          '${DBConstants.productQuantity} INTEGER, '
          '${DBConstants.cartDetail} VARCHAR)',
        );
      },
      version: 1,
    ).then((value) => database = value);
  }

  Future<int> insertCartDetails(Product cartDetail) async {
    var data = <String, String>{};
    data[DBConstants.cartDetail] = jsonEncode(cartDetail);
    data[DBConstants.productId] = cartDetail.id.toString();
    data[DBConstants.productQuantity] = "1";

    var cartItem = await database.query(DBConstants.cartDetailTable,
        where: '${DBConstants.productId} = ?', whereArgs: [cartDetail.id.toString()]);
    if (cartItem.isEmpty) {
      return await database.insert(
        DBConstants.cartDetailTable,
        data,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      updateItem(cartDetail);
      return 0;
    }
  }

  Future<List<Cart>> getCartItems() async {
    var data = await database.query(DBConstants.cartDetailTable);
    final list = <Cart>[];
    for (int i = 0; i < data.length; i++) {
      String product = data[i].values.toList()[3].toString();
      final values = json.decode(product);
      Cart cart = Cart(Product.fromJson(values), data[i].values.toList()[2].toString());
      list.add(cart);
    }
    debugPrint("List = ${list.length}");
    return list;
  }

  updateItem(Product cartDetail) async {
    var data = await database.query(DBConstants.cartDetailTable,
        columns: [DBConstants.productQuantity],
        where: '${DBConstants.productId} = ?', whereArgs: [cartDetail.id.toString()]);
    debugPrint('data = $data');
    String productQuantity = data[0].values.toList()[0].toString();
    return await database.rawUpdate(
        'UPDATE ${DBConstants.cartDetailTable} SET ${DBConstants.productQuantity} = ? WHERE ${DBConstants.productId} = ?',
        [int.parse(productQuantity) + 1, cartDetail.id]);
  }
//
// Future<int> removeTyreDetails(String timeStamp) {
//   return database.delete(DBConstants.tyreDetailTable,
//       where: '${DBConstants.timeStamp} =? ', whereArgs: [timeStamp]);
// }
}
