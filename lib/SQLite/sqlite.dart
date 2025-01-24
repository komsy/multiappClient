import 'package:multiapp/env.dart';
import 'package:multiapp/features/authentication/models/user/user_model.dart';
import 'package:multiapp/features/personalization/models/Setting_model.dart';
import 'package:multiapp/features/shop/models/credit_customer_model.dart';
import 'package:multiapp/features/shop/models/customer_model.dart';
import 'package:multiapp/features/shop/models/order_item_model.dart';
import 'package:multiapp/features/shop/models/order_model.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/features/shop/models/product_packing_price.dart';
import 'package:multiapp/features/shop/models/product_unit_converter.dart';
import 'package:multiapp/utils/popups/loaders.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:developer';
import 'package:uuid/uuid.dart';

// Create the categoryMst table
class LocalDatabase {
  static String fileName = "multitech_data.db";
  // Singleton instance
  static final LocalDatabase instance = LocalDatabase._init();

  // Private constructor
  LocalDatabase._init();

  static Database? _database;
  final Uuid uuid = const Uuid();

  String createAppKey() {
    // Generate a new UUID (Version 4 by default)
    return uuid.v4().toUpperCase();
  }

  /// Hashes a password using SHA-256
  String hashPassword(String password) {
    var bytes =
        utf8.encode(password); // Convert the password to a list of bytes
    var digest = sha256.convert(bytes); // Hash using SHA-256
    return digest.toString(); // Convert hash to a hex string
  }

  /// Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, initialize it
    _database = await _initDB('multitech_data.db');
    return _database!;
  }

  /// Function to initialize the database
  static Future<Database> _initDB(String fileName) async {
    try {
      // Get the database path
      String dbPath = join(await getDatabasesPath(), fileName);

      // Open or create the database
      return await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    } catch (e) {
      MLoaders.errorSnackBar(
          title: 'Oh Snap!', message: 'Failed to initialize database: $e');
      rethrow; // Propagate the error if needed
    }
  }

  /// Function to handle database upgrades
  static Future<void> _upgradeDB(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Add upgrade logic, e.g., ALTER TABLE or add new tables
      // print("Database upgraded from version $oldVersion to $newVersion.");
    }
  }

// Function to create tables in the database
  static Future<void> _createDB(Database db, int version) async {
    // Create the categoryMst table
    await db.execute('''
      CREATE TABLE categoryMst (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        catCode VARCHAR(30) UNIQUE NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        catName VARCHAR(150) NOT NULL,
        image VARCHAR(250)
      )
    ''');
    // Create the productMst table
    await db.execute('''
      CREATE TABLE productMst (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itmCode VARCHAR(30) UNIQUE NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        godownName VARCHAR(100) NOT NULL,
        longName VARCHAR(150) NOT NULL,
        taxCode VARCHAR(1) NOT NULL,
        taxRate INTEGER NOT NULL,
        RspAmount REAl NOT NULL,
        catCode VARCHAR(30) NOT NULL,
        catName VARCHAR(100) NOT NULL,
        unit VARCHAR(15) NOT NULL,
        fixUnitOfSell VARCHAR(15) NOT NULL,
        currBalance INTEGER NOT NULL,
        wspIncVat REAl NOT NULL,
        isFavourite VARCHAR(2) NOT NULL,
        image VARCHAR(250)
      )
    ''');

    // Create the ProductUnitConverter table
    // await db.execute('''
    //   CREATE TABLE ProductUnitConverter (
    //     PRIMARY KEY (itmCode, bulkPackUnit) -- Composite Primary Key to enforce uniqueness
    //     itmCode VARCHAR(30) NOT NULL,UNIQUE (itmCode, basePackUnit) -- Enforces uniqueness for this combination
    //     locationId VARCHAR(2) NOT NULL,
    //     bulkPackQty REAl NOT NULL,
    //     bulkPackUnit VARCHAR(15) NOT NULL,
    //     basePackQty REAl NOT NULL,
    //     basePackUnit VARCHAR(15) NOT NULL
    //   )
    // ''');

    // Create the ProductPackingPrice table
    await db.execute('''
      CREATE TABLE ProductPackingPrice (
        
        itmCode VARCHAR(30) NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        basePackQty REAl NOT NULL,
        bulkPackUPrice REAl NOT NULL,
        bulkPackUnit VARCHAR(15) NOT NULL,
        scanCode VARCHAR(30) NOT NULL,
        PRIMARY KEY (itmCode, bulkPackUnit)
      )
    ''');

    // Create the customerMst table
    await db.execute('''
      CREATE TABLE customerMst (
        customerCode VARCHAR(30) UNIQUE NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        companyName VARCHAR(150) NOT NULL,
        accType VARCHAR(10) NOT NULL,
        crLimit REAl NOT NULL,
        currBalance REAl NOT NULL
      )
    ''');

    // Create the credit customer table
    await db.execute('''
      CREATE TABLE creditCustomer (
        customerName VARCHAR(100) UNIQUE NOT NULL,
        phoneNumber VARCHAR(15) NOT NULL,
        pinNo VARCHAR(12),
        address VARCHAR(50),
        selectedCrCustomer INTEGER NOT NULL
      )
    ''');

    // Create the orders table
    // docNo TEXT NOT NULL,
    // orderSeries VARCHAR(10) NOT NULL,
    await db.execute('''
      CREATE TABLE orderMst (
        id INTEGER NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        orderDate VARCHAR(30) NOT NULL,
        customerCode VARCHAR(30) NOT NULL,
        companyName VARCHAR(150) NOT NULL,
        totalAmount REAl NOT NULL,
        paymentMethod TEXT NOT NULL,
        naration TEXT NOT NULL,
        orderStatus VARCHAR(20),
        cashCustomerName VARCHAR(100),
        cashPhoneNumber VARCHAR(15),
        cashPinNo VARCHAR(12),
        cashAddress VARCHAR(50),
        createdBy VARCHAR(10) NOT NULL,
        createdAt VARCHAR(30) NOT NULL
      )
    ''');

    //Create order details table
    // docNo VARCHAR(20) NOT NULL,
    await db.execute('''
      CREATE TABLE orderTrn (
        orderId INTEGER NOT NULL,
        locationId VARCHAR(2) NOT NULL,
        itmCode VARCHAR(30) NOT NULL,
        longName VARCHAR(150) NOT NULL,
        quantity INTEGER NOT NULL,
        unit VARCHAR(10) NOT NULL,
        basicUnit VARCHAR(10) NOT NULL,
        defaultPricing VARCHAR(10) NOT NULL,
        vatCode VARCHAR(1) NOT NULL,
        vatRate INTEGER NOT NULL,
        exVat REAl NOT NULL,
        vatAmount REAl NOT NULL,
        costPrice REAl NOT NULL,
        amount REAl NOT NULL,
        createdBy VARCHAR(10) NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create the userMst table
    await db.execute('''
      CREATE TABLE userMst (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        status INTEGER NOT NULL,
        refreshToken TEXT,
        role varchar(10) NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create the settings table
    await db.execute('''
      CREATE TABLE settings (
        appKey VARCHAR(100) UNIQUE NOT NULL,
        androidId VARCHAR(200),
        APIURL VARCHAR(250),
        APIKey VARCHAR(250),
        locationId VARCHAR(2) NOT NULL,
        docSeries VARCHAR(20),
        defaultCustomer VARCHAR(150),
        docNo INTEGER  NOT NULL,
        IsRSP INTEGER  NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Insert a test product into productMst table
  Future<void> insertTestProduct() async {
    final db = await instance.database;
    // final db = await _initDB(fileName);
    // Get the current Unix timestamp
    int createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // Hash the password before storing it in the database
    String hashedPassword = hashPassword("@Admin123");
    final appKey = createAppKey();

    // await db.insert("categoryMst", {
    //   "catCode": "01001",
    //   "catName": "GENERAL ITEM",
    //   "locationId": "00",
    //   "image": "",
    // });
    // // Test product data
    // Map<String, dynamic> testProduct = {
    //   "itmCode": "070098",
    //   "locationId": "01",
    //   "godownName": "HO",
    //   "longName": "Test Product",
    //   "taxCode": "A",
    //   "taxRate": 16,
    //   "catCode": "01001",
    //   "catName": "GENERAL ITEM",
    //   "RspAmount": 15,
    //   "unit": "PCS",
    //   "currBalance": 20,
    //   "wspIncVat": 13,
    //   "isFavourite": "0",
    //   "image": "",
    // };

    // await db.insert("productMst", testProduct,
    //     conflictAlgorithm: ConflictAlgorithm.replace);

    // // Optionally, insert data into the related tables
    // await db.insert("ProductUnitConverter", {
    //   "itmCode": "070098",
    //   "locationId": "01",
    //   "bulkPackQty": 1,
    //   "bulkPackUnit": "PCS",
    //   "basePackQty": 1,
    //   "basePackUnit": "PCS",
    // });

    // await db.insert("ProductPackingPrice", {
    //   "itmCode": "070098",
    //   "locationId": "01",
    //   "basePackQty": 1,
    //   "bulkPackUPrice": 12.0,
    //   "bulkPackUnit": "PCS",
    //   "scanCode": "070098",
    // });
    // await db.insert("customerMst", {
    //   "customerCode": "MS000001",
    //   "companyName": "Multitech Solution ltd",
    //   "locationId": "00",
    //   "accType": "AC",
    //   "crLimit": 100.0,
    //   "currBalance": 10.0,
    // });
    await db.insert("settings", {
      "appKey": appKey,
      "androidId": "",
      "APIURL": "",
      "APIKey": "",
      "docSeries": "",
      "defaultCustomer": "Cash Sale",
      "locationId": "00",
      "docNo": 0,
      "IsRSP": 0,
      "createdAt": "2024-11-20T15:20:20.621511",
    });

    await db.insert("userMst", {
      "username": "admin",
      "email": "admin@gmail.com",
      "password": hashedPassword,
      "refreshToken": "",
      "role": "user",
      "status": 1,
      "createdAt": createdAt,
    });
  }

  Future<List<Map<dynamic, dynamic>>?> login(
      String email, String password) async {
    // Open the SQLite database
    final db = await instance.database;
    // Fetch the user by email
    List<Map> result = await db.rawQuery(
        'SELECT * FROM userMst WHERE status =1 AND  email = ?', [email]);

    if (result.isNotEmpty) {
      return result; // Return user data if found
    } else {
      return null; // Return null if no user is found
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    // Open the SQLite database
    final db = await instance.database;
    // Fetch all category products
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM userMst WHERE status =1');

    // Return the first row or null if no data is found
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<dynamic, dynamic>>?> getCategories() async {
    // Open the SQLite database
    final db = await instance.database;
    // Fetch all categories
    List<Map> result = await db.rawQuery('SELECT * FROM categoryMst');

    if (result.isNotEmpty) {
      return result; // Return categories data if found
    } else {
      return null; // Return null if no categories is found
    }
  }

  Future<List<Map<dynamic, dynamic>>?> getCategoryProducts(
      String categoryId) async {
    // Open the SQLite database
    final db = await instance.database;
    // final tableName= Env.pr
    // Fetch all category products
    List<Map> result = await db
        .rawQuery('SELECT * FROM productMst WHERE  catCode = ?', [categoryId]);

    if (result.isNotEmpty) {
      return result; // Return category products data if found
    } else {
      return null; // Return null if no category products is found
    }
  }

  Future<void> updateFavProduct(int isFavourite, String productId) async {
    final db = await instance.database;
    // print('updateFavProduct: $isFavourite, $productId');
    await db.transaction((txn) async {
      await txn.rawQuery(
        'UPDATE productMst SET isFavourite = ? WHERE itmCode = ?',
        [isFavourite, productId],
      );
    });
  }

  //Save app Settings
  Future<void> saveSelectedCrClient(CreditCustomerModel customer) async {
    // print(customer.toJson());
    final db = await database;
    await db.insert(
      'creditCustomer',
      customer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent overwriting
    );
  }

  //Save app Settings
  Future<void> saveAppSettings(SettingModel settings) async {
    final db = await database;
    await db.insert(
      'settings',
      settings.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent overwriting
    );
  }

  Future<int> updateAppSettings(isRSP) async {
    final db = await instance.database;
    return await db.update(
      'settings',
      {'IsRSP': isRSP},
      // where: 'id = ?', // Replace with actual condition to identify the user
      // whereArgs: [userId], // Replace `userId` appropriately
    );
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all customers
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM customerMst') as List<Map<String, dynamic>>;

    if (result.isNotEmpty) {
      return result; // Return customers data if found
    } else {
      return []; // Return null if no customers are found
    }
  }

  //Search specific customer
  Future<List<Map<String, dynamic>>> getCustomerSearch(keyWord) async {
    // Open the SQLite database
    print("keyword: $keyWord");
    final db = await instance.database;
    // Fetch all customers
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM customerMst WHERE companyName LIKE ?',
      ['%$keyWord%'],
    );

    if (result.isNotEmpty) {
      return result; // Return customers data if found
    } else {
      return []; // Return null if no customers is found
    }
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all active products
    // List<Map<String, dynamic>> products =
    //     await db.rawQuery('SELECT * FROM productMst WHERE isFavourite=1');
    // Fetch all favorite products
    List<Map<String, dynamic>> products =
        await db.rawQuery('SELECT * FROM productMst ORDER BY isFavourite DESC LIMIT 20');

    // if (products.isEmpty) {
    //   // Fetch the top 20 products if no favorites are found
    //   products = await db.rawQuery('SELECT * FROM productMst LIMIT 20');
    // }
    // Check if products were found
    if (products.isNotEmpty) {
      // Create a new list to hold updated products with related data
      List<Map<String, dynamic>> updatedProducts = [];

      // Iterate through each product and fetch related data
      for (var product in products) {
        // Fetch related data from ProductUnitConverter
        // List<Map<String, dynamic>> unitConverterData = await db.rawQuery(
        //   'SELECT * FROM ProductUnitConverter WHERE itmCode = ?', [product['itmCode']],
        // );

        // Fetch related data from ProductPackingPrice
        List<Map<String, dynamic>> packingPriceData = await db.rawQuery(
          'SELECT * FROM ProductPackingPrice WHERE itmCode = ?',
          [product['itmCode']],
        );

        // Create a new map that combines the product with related data
        Map<String, dynamic> productWithRelatedData = {
          ...product, // Copy the original product fields
          // 'ProductUnitConverter': unitConverterData,
          'ProductPackingPrice': packingPriceData,
        };

        // Add the updated product to the new list
        updatedProducts.add(productWithRelatedData);
      }
      return updatedProducts; // Return the updated list of products
    } else {
      return products; // Return an empty list if no products found
    }
  }

  Future<List<Map<String, dynamic>>> getProductSearch(keyWord) async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all active products
    List<Map<String, dynamic>> products = await db.rawQuery(
      'SELECT * FROM productMst WHERE longName LIKE ?  LIMIT 20',
      ['%$keyWord%'],
    );

    // Check if products were found
    if (products.isNotEmpty) {
      // Create a new list to hold updated products with related data
      List<Map<String, dynamic>> updatedProducts = [];

      // Iterate through each product and fetch related data
      for (var product in products) {
        // Fetch related data from ProductUnitConverter
        // List<Map<String, dynamic>> unitConverterData = await db.rawQuery(
        //   'SELECT * FROM ProductUnitConverter WHERE itmCode = ?',[product['itmCode']],
        // );

        // Fetch related data from ProductPackingPrice
        List<Map<String, dynamic>> packingPriceData = await db.rawQuery(
          'SELECT * FROM ProductPackingPrice WHERE itmCode = ?',
          [product['itmCode']],
        );

        // Create a new map that combines the product with related data
        Map<String, dynamic> productWithRelatedData = {
          ...product, // Copy the original product fields
          // 'ProductUnitConverter': unitConverterData,
          'ProductPackingPrice': packingPriceData,
        };

        // Add the updated product to the new list
        updatedProducts.add(productWithRelatedData);
      }
      return updatedProducts; // Return the updated list of products
    } else {
      return products; // Return an empty list if no products found
    }
  }

  Future<List<Map<dynamic, dynamic>>?> getOrders() async {
    // Open the SQLite database
    final db = await instance.database;
    // final tableName= Env.pr
    // Fetch all category orders
    List<Map<String, dynamic>> orders =
        await db.rawQuery('SELECT * FROM orderMst');

    // Check if orders were found
    if (orders.isNotEmpty) {
      // Create a new list to hold updated orders with related data
      List<Map<String, dynamic>> updatedOrders = [];

      // Iterate through each order and fetch related data
      for (var order in orders) {
        // Fetch related data from OrderItems
        List<Map<String, dynamic>> orderItemsData = await db.rawQuery(
          'SELECT * FROM orderTrn WHERE orderId = ?',
          [order['id']],
        );

        // Create a new map that combines the order with related data
        Map<String, dynamic> orderWithRelatedData = {
          ...order, // Copy the original order fields
          'OrderItems': orderItemsData,
        };

        // Add the updated order to the new list
        updatedOrders.add(orderWithRelatedData);
      }

      return updatedOrders; // Return the updated list of orders
    } else {
      return orders; // Return an empty list if no orders found
    }
  }

  // Get settings
  Future<Map<String, dynamic>?> getSingleAppSetting() async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all customers
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM settings');
    // Return the first row or null if no data is found
    return result.isNotEmpty ? result.first : null;
  }

 Future<List<Map<String, dynamic>>> getCreditCustomer() async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all customers
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM creditCustomer') as List<Map<String, dynamic>>;

    if (result.isNotEmpty) {
      return result; // Return customers data if found
    } else {
      return []; // Return null if no customers are found
    }
  }

  Future<int> updatePassword(String hashedPassword) async {
    final db = await instance.database;
    return await db.update(
      'userMst',
      {'password': hashedPassword},
      // where: 'id = ?', // Replace with actual condition to identify the user
      // whereArgs: [userId], // Replace `userId` appropriately
    );
  }

    Future<int> updateSelectedField(String selectedCrClient, int isActive) async {
    final db = await instance.database;
    return await db.update(
      'creditCustomer',
      {'selectedCrCustomer': isActive},
      where: 'customerName = ?', // Replace with actual condition to identify the user
      whereArgs: [selectedCrClient], // Replace `userId` appropriately
    );
  }

  //Truncate products table after calling the API
  Future<void> truncateProductTable() async {
    final db = await instance.database;
    await db.delete('productMst');
  }

  Future<void> truncateOrderMst() async {
    final db = await instance.database;
    await db.delete('orderMst');
  }

  Future<void> truncateCategoryMst() async {
    final db = await instance.database;
    await db.delete('categoryMst');
  }

  Future<void> truncateCustomerMst() async {
    final db = await instance.database;
    await db.delete('customerMst');
  }

  //Truncate products table after calling the API
  Future<void> truncateProductUnitTable() async {
    final db = await instance.database;
    await db.delete('ProductUnitConverter');
  }

  //Truncate products table after calling the API
  Future<void> truncateProductPackagingTable() async {
    final db = await instance.database;
    await db.delete('ProductPackingPrice');
  }

  // Insert user
  Future<void> insertUser(UserModel users) async {
    final db = await instance.database;
    await db.delete('userMst');
    await db.insert(
      'userMst',
      users.toJson(), // Converts the object to a JSON map for inserting into the database
      conflictAlgorithm: ConflictAlgorithm.replace, // Optional: to handle duplicate entries
    );
  }

  //Insert products from the API
  Future<void> insertAPIProduct(ProductModels product) async {
    final db = await instance.database;
    await db.insert(
      'productMst',
      product.toJson(), // Converts the object to a JSON map for inserting into the database
      conflictAlgorithm:ConflictAlgorithm.replace, // Optional: to handle duplicate entries
    );
  }

  //Insert products from the API
  Future<void> insertAPIProductUnitC(ProductUnitConverter product) async {
    final db = await instance.database;
    await db.insert(
      'ProductUnitConverter',
      product.toJson(), // Converts the object to a JSON map for inserting into the database
      conflictAlgorithm:ConflictAlgorithm.replace, // Optional: to handle duplicate entries
    );
  }

  //Insert products from the API
  Future<void> insertAPIProductPP(ProductPackingPrice product) async {
    final db = await instance.database;
    await db.insert(
      'ProductPackingPrice',
      product.toJson(), // Converts the object to a JSON map for inserting into the database
      conflictAlgorithm: ConflictAlgorithm.replace, // Optional: to handle duplicate entries
    );
  }

  // Future<void> insertAPICategoryMst(CategoryModel category) async {
  //   final db = await instance.database;
  //   await db.insert(
  //     'categoryMst',
  //     category.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<void> insertAPICustomerMst(CustomerModel customer) async {
    final db = await instance.database;
    await db.insert(
      'customerMst',
      customer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Save Order
  Future<void> saveOrders(OrderModel order) async {
    print("order: ${order.cashCustomerName}: ${order.cashPhoneNumber}");
    final db = await database;
    await db.insert(
      'orderMst',
      order.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent overwriting
    );
  }

  //Save Order Items
  Future<void> saveOrderItem(OrderItemModel orderItem) async {
    final db = await instance.database;
    await db.insert(
      'orderTrn',
      orderItem.toJson(), // Converts the object to a JSON map for inserting into the database
      conflictAlgorithm: ConflictAlgorithm.ignore, // Optional: to handle duplicate entries
    );
  }

  // Insert data into the "multitechData" table
  Future<void> addDataLocallyy({required String name}) async {
    // final db = await database;
    final db = await instance.database;

    // Insert data into the table
    await db.insert(
      "productMst",
      {"name": name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Data added: $name');
  }

  Future readAllData({name}) async {
    final db = await instance.database;
    // final db = await database;
    final productMst = await db.query("orderMst");
    final orderTrn = await db.query("orderTrn");
    // final userMst =  await db.query("userMst");
    // final categoryMst =  await db.query("categoryMst");
    // final settings =  await db.query("settings");
    log("productMst $productMst");
    log("orderTrn $orderTrn");
    // print(userMst);
    // print(categoryMst);
    // print(settings);
    return 'read';
  }

  Future<void> resetDatabase() async {
    try {
      // Close the database if it's still open
      // if (_database != null) {
      //   await _database!.close();
      // }

      // Delete the database file
      String path = join(await getDatabasesPath(), fileName);
      await deleteDatabase(path);
      print("filename $fileName");
      print("path $path");
      // Clear the instance and reinitialize
      _database = null;
      // await _initDB(fileName);

      print("Database has been reset successfully.");
    } catch (e) {
      print("Error resetting database: $e");
    }
  }

  // Example function to delete all categories
  Future<void> deleteAllCategories() async {
    final db = await database;
    await db.delete('categoryMst');
    print("All data from categoryMst has been deleted.");
  }

  /// Function to close the database
  // Future<void> close() async {
  //   if (_database != null) {
  //     await _database!.close();
  //     _database = null;
  //     print("Database closed.");
  //   }
  // }
  Future close() async {
    final db = await instance.database;
    _database = null;
    return db.close();
  }

  ///

  // Future<void> close() async {
  //   final db = await database;
  //   return db.close();
  // }
}
