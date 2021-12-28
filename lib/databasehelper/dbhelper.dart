import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "gomarket.db";
  static final _databaseVersion = 4;

  static final table = 'producttable';
  static final pharmatable = 'pharmaproduct';
  static final pharmaadon = 'pharmaadon';
  static final resturantOrder = 'resturantorder';
  static final addontable = 'addontable';
  static final faviourteResturant = 'faviourteResturant';
  static final faviourteProdcutRest = 'faviourteProdcutRest';

  static final columnId = '_id';
  static final productName = 'product_name';
  static final quantitiy = 'qnty';
  static final price = 'price';
  static final unit = 'unit';
  static final addQnty = 'add_qnty';
  static final varientId = 'varient_id';
  static final productImage = 'product_img';

  static final vendor_name = 'vendor_name';
  static final vendor_phone = 'vendor_phone';
  static final vendor_id = 'vendor_id';
  static final vendor_logo = 'vendor_logo';
  static final vendor_category_id = 'vendor_category_id';
  static final distance = 'distance';
  static final lat = 'lat';
  static final lng = 'lng';
  static final delivery_range = 'delivery_range';

  static final productNameR = 'productname';
  static final productId = 'productId';
  static final addonid = 'addonid';
  static final addonName = 'addonname';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS $table');
    batch.execute('DROP TABLE IF EXISTS $faviourteResturant');
    batch.execute('DROP TABLE IF EXISTS $resturantOrder');
    batch.execute('DROP TABLE IF EXISTS $addontable');
    batch.execute('DROP TABLE IF EXISTS $faviourteProdcutRest');
    batch.execute('DROP TABLE IF EXISTS $pharmatable');
    batch.execute('DROP TABLE IF EXISTS $pharmaadon');
    await batch.commit().then((value) {
      print('table drop - $value');
      _onCreate(db, newVersion);
    });
  }

  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    // batch.execute(sql)
    batch.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $productName TEXT NOT NULL,
            $quantitiy INTEGER NOT NULL,
            $price REAL NOT NULL,
            $unit TEXT NOT NULL,
            $addQnty INTEGER NOT NULL,
            $varientId TEXT NOT NULL,
            $productImage TEXT NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $faviourteResturant (
            $columnId INTEGER PRIMARY KEY,
            $vendor_name TEXT NOT NULL,
            $vendor_phone TEXT NOT NULL,
            $vendor_id TEXT NOT NULL,
            $vendor_logo TEXT NOT NULL,
            $vendor_category_id TEXT NOT NULL,
            $distance TEXT NOT NULL,
            $lat TEXT NOT NULL,
            $lng TEXT NOT NULL,
            $delivery_range TEXT NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $resturantOrder (
            $columnId INTEGER PRIMARY KEY,
            $productId TEXT NOT NULL,
            $varientId TEXT NOT NULL,
            $productName TEXT NOT NULL,
            $quantitiy INTEGER NOT NULL,
            $unit TEXT NOT NULL,
            $price REAL NOT NULL,
            $addQnty INTEGER NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $addontable (
          $columnId INTEGER PRIMARY KEY,
            $varientId TEXT NOT NULL,
            $addonid TEXT NOT NULL,
            $addonName TEXT NOT NULL,
            $price REAL NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $pharmatable (
            $columnId INTEGER PRIMARY KEY,
            $productId TEXT NOT NULL,
            $varientId TEXT NOT NULL,
            $productName TEXT NOT NULL,
            $quantitiy INTEGER NOT NULL,
            $unit TEXT NOT NULL,
            $price REAL NOT NULL,
            $addQnty INTEGER NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $pharmaadon (
          $columnId INTEGER PRIMARY KEY,
            $varientId TEXT NOT NULL,
            $addonid TEXT NOT NULL,
            $addonName TEXT NOT NULL,
            $price REAL NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE $faviourteProdcutRest (
          $columnId INTEGER PRIMARY KEY,
            $productId TEXT NOT NULL,
            $varientId TEXT NOT NULL
          )
          ''');
    await batch.commit().then((value) {
      print('table created - $value');
    });
  }

  //pharmacy database

  Future<List<Map<String, dynamic>>> getPharmaProduct() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT $pharmatable.$varientId, $pharmatable.$addQnty, $pharmatable.$quantitiy, $pharmatable.$unit, $pharmatable.$price, $pharmatable.$productName FROM $pharmatable');
  }

  Future<List<Map<String, dynamic>>> getAddOnListPharma(dynamic id) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $pharmaadon WHERE $varientId=$id');
  }

  Future<dynamic> calculateTotalpharma() async {
    Database db = await instance.database;
    var result = db.rawQuery("SELECT SUM($price) as Total FROM $pharmatable");
    return result;
  }

  Future<dynamic> calculateTotalPharmaAdon() async {
    Database db = await instance.database;
    var result2 = db.rawQuery("SELECT SUM($price) as Total FROM $pharmaadon");
    return result2;
  }

  Future<int> deleteAllPharma() async {
    Database db = await instance.database;
    return await db.delete(pharmatable);
  }

  Future<int> deleteAllAddonPharma() async {
    Database db = await instance.database;
    return await db.delete(pharmaadon);
  }

  Future<int> deleteAddOnPharma(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(pharmaadon, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> deleteAddOnIdPharma(dynamic id) async {
    Database db = await instance.database;
    return await db.delete(pharmaadon, where: '$addonid = ?', whereArgs: [id]);
  }

  Future<int> deleteAddOnIdPharmaWithVid(dynamic id, dynamic vid) async {
    Database db = await instance.database;
    return await db.delete(pharmaadon,
        where: '$addonid = ? AND $varientId = ?', whereArgs: [id, vid]);
  }

  Future<int> getPharmaCount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM $pharmatable WHERE $varientId=$id"));
    return count;
  }

  Future<int> insertPharmaOrder(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(pharmatable, row);
  }

  Future<int> insertPharmaAddOn(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(pharmaadon, row);
  }

  Future<int> deletePharmaProduct(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(pharmatable, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> deletePharmaAddOn(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(pharmaadon, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> updatePharmaProductData(
      Map<String, dynamic> row, dynamic vat) async {
    Database db = await instance.database;
//    int id = row[vat];
    return await db
        .update(pharmatable, row, where: '$varientId = ?', whereArgs: [vat]);
  }

  Future<int> queryRowPharmaCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $pharmatable'));
  }

  Future<int> getVarientPharmaCount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT $addQnty FROM $pharmatable WHERE $varientId=$id"));
    return count;
  }

  Future<int> getPharmaCountAddon(dynamic id, dynamic varidid) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $pharmaadon WHERE $addonid=$id AND $varientId=$varidid"));
    return count;
  }

  //

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertRaturant(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(faviourteResturant, row);
  }

  Future<int> insertRaturantOrder(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(resturantOrder, row);
  }

  Future<int> insertAddOn(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(addontable, row);
  }

  Future<int> insertFaviProduct(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(faviourteProdcutRest, row);
  }

  Future<List<Map<String, dynamic>>> getFaviourteProduct(dynamic id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT $varientId FROM $faviourteProdcutRest WHERE $productId=$id');
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsResturant() async {
    Database db = await instance.database;
    return await db.query(faviourteResturant);
  }

  Future<List<Map<String, dynamic>>> getAddOnList(dynamic id) async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT $addonid FROM $addontable WHERE $varientId=$id');
  }

  Future<List<Map<String, dynamic>>> getAddOnListWithPrice(dynamic id) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $addontable WHERE $varientId=$id');
  }

  Future<List<Map<String, dynamic>>> getResturantOrderList() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT $resturantOrder.$varientId, $resturantOrder.$addQnty, $resturantOrder.$quantitiy, $resturantOrder.$unit, $resturantOrder.$price, $resturantOrder.$productName FROM $resturantOrder');
  }

  Future<int> getcountRestcount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $faviourteResturant WHERE $vendor_id=$id"));
    return count;
  }

  Future<int> getCountAddon(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM $addontable WHERE $addonid=$id"));
    return count;
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> queryRowCountRest() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $resturantOrder'));
  }

  Future<int> queryRowBothCount() async {
    Database db = await instance.database;
    int counttable1 =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
    int counttable2 = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $resturantOrder'));
    return (counttable1 + counttable2);
  }

  Future<int> queryResturantProdCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $resturantOrder'));
  }

  Future<int> updateData(Map<String, dynamic> row, int vat) async {
    Database db = await instance.database;
    return await db
        .update(table, row, where: '$varientId = ?', whereArgs: [vat]);
  }

  Future<int> updateRestProductData(
      Map<String, dynamic> row, dynamic vat) async {
    Database db = await instance.database;
    return await db
        .update(resturantOrder, row, where: '$varientId = ?', whereArgs: [vat]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> deleteResProduct(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(resturantOrder, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> deleteResturant(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(faviourteResturant, where: '$vendor_id = ?', whereArgs: [id]);
  }

  Future<int> deleteAddOn(dynamic id) async {
    Database db = await instance.database;
    return await db
        .delete(addontable, where: '$varientId = ?', whereArgs: [id]);
  }

  Future<int> deleteAddOnId(dynamic id) async {
    Database db = await instance.database;
    return await db.delete(addontable, where: '$addonid = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> deleteAllRestProdcut() async {
    Database db = await instance.database;
    return await db.delete(resturantOrder);
  }

  Future<int> deleteAllAddOns() async {
    Database db = await instance.database;
    return await db.delete(addontable);
  }

  Future<int> getcount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $varientId=$id"));
    return count;
  }

  Future<int> getRestProductcount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM $resturantOrder WHERE $varientId=$id"));
    return count;
  }

  Future<int> getRestProdByProId(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM $resturantOrder WHERE $productId=$id"));
    return count;
  }

  Future<int> getVarientCount(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT $addQnty FROM $table WHERE $varientId=$id"));
    return count;
  }

  Future<int> getRestProdQty(dynamic id) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT $addQnty FROM $resturantOrder WHERE $varientId=$id"));
    return count;
  }

  Future<dynamic> getSumPrice() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT SUM($price) FROM $table');
  }

  Future<dynamic> calculateTotal() async {
    Database db = await instance.database;
    var result = db.rawQuery("SELECT SUM($price) as Total FROM $table");
    return result;
  }

  Future<dynamic> calculateTotalRest() async {
    Database db = await instance.database;
    var result =
        db.rawQuery("SELECT SUM($price) as Total FROM $resturantOrder");
    return result;
  }

  Future<dynamic> calculateTotalRestAdon() async {
    Database db = await instance.database;
    var result2 = db.rawQuery("SELECT SUM($price) as Total FROM $addontable");
    return result2;
  }

  Future<dynamic> calculateTotalRestAdonA(dynamic id) async {
    Database db = await instance.database;
    var result2 = db.rawQuery(
        "SELECT SUM($price) as Total FROM $addontable WHERE $varientId=$id");
    return result2;
  }
}
