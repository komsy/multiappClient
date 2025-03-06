import 'dart:developer';

import 'package:easyapp/features/authentication/models/user/user_model.dart';
import 'package:easyapp/features/personalization/models/setting_model.dart';
import 'package:easyapp/features/shop/models/credit_customer_model.dart';
import 'package:easyapp/features/shop/models/customer_model.dart';
import 'package:easyapp/features/shop/models/order_item_model.dart';
import 'package:easyapp/features/shop/models/order_model.dart';
import 'package:easyapp/features/shop/models/product_model.dart';
import 'package:easyapp/features/shop/models/product_packing_price.dart';
import 'package:easyapp/features/shop/models/product_unit_converter.dart';
import 'package:easyapp/utils/popups/loaders.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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

  // String createAppKey() {
  //   // Generate a new UUID (Version 4 by default)
  //   return uuid.v4().toUpperCase();
  // }
  String createAppKey() {
  // var uuid = const Uuid();
  String baseKey = uuid.v4().toUpperCase().substring(0, 8); // Truncate to 8 characters

  // Get current time
  final now = DateTime.now();
  String formattedTime = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

  // Concatenate key with time
  //950ED57B155134
  return "$baseKey$formattedTime";
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
        isSent INTEGER  NOT NULL,
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

    // Create the settings table
    await db.execute('''
      CREATE TABLE settings (
        appKey VARCHAR(100) UNIQUE NOT NULL,
        APIURL VARCHAR(250),
        APIKey VARCHAR(250),
        locationId VARCHAR(2) NOT NULL,
        defaultCustCode VARCHAR(10),
        defaultPricing VARCHAR(10) NOT NULL,
        routeWiseSell INTEGER  NOT NULL,
        editOrder INTEGER  NOT NULL,
        editAfter INTEGER  NOT NULL,
        orderDays INTEGER  NOT NULL,
        orderRecordDays INTEGER  NOT NULL,
        setDefaultCust INTEGER  NOT NULL,
        IsRSP INTEGER  NOT NULL,
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
        userStatus INTEGER NOT NULL,
        licStatus INTEGER NOT NULL,
        refreshToken TEXT,
        role varchar(10) NOT NULL,
        updatedAt TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    
    // Create the orderRecords table
    await db.execute('''
      CREATE TABLE orderRecords (
        noofOrders INTEGER NOT NULL,
        total REAl NOT NULL,
        date TEXT UNIQUE
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

    await db.insert("settings", {
      "appKey": appKey,
      "APIURL": "",
      "APIKey": "",
      "locationId": "00",
      "defaultCustCode": "",
      "defaultPricing": "WSP",
      "routeWiseSell": 0,
      "setDefaultCust": 0,
      "editOrder": 0,
      "editAfter": 0,
      "orderDays": 1,
      "orderRecordDays": 7,
      "IsRSP": 0,
      "createdAt": createdAt,
    });

    await db.insert("userMst", {
      "username": "admin",
      "email": "admin@multitech.co.ke",
      "password": hashedPassword,
      "refreshToken": "",
      "role": "user",
      "status": 1,
      "userStatus": 1,
      "licStatus": 1,
      "updatedAt": createdAt,
      "createdAt": createdAt,
    });
  }

  Future<List<Map<dynamic, dynamic>>?> login(
      String email) async {
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

  //Save app CreditCustomerModel
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
    // print("keyword: $keyWord");
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

  Future<List<Map<dynamic, dynamic>>?> getOrders(int orderDays,  bool isSending) async {
    final db = await instance.database;

    // Clean up old orders before fetching current ones
    await _deleteOldOrders(db, orderDays);

    // Define the query dynamically based on isSending
    String query = isSending 
      ? 'SELECT * FROM orderMst WHERE isSent=0 ORDER BY createdAt DESC'
      : 'SELECT * FROM orderMst ORDER BY createdAt DESC';

    // Execute the query
    List<Map<String, dynamic>> orders = await db.rawQuery(query);
    
    if (orders.isNotEmpty) {
      List<Map<String, dynamic>> updatedOrders = [];

      for (var order in orders) {
        // Fetch related order items
        List<Map<String, dynamic>> orderItemsData = await db.rawQuery(
          'SELECT * FROM orderTrn WHERE orderId = ?', [order['id']]
        );

        // Combine order details with order items
        updatedOrders.add({
          ...order,
          'OrderItems': orderItemsData,
        });
      }

      return updatedOrders;
    } else {
      return orders; // Return empty list if no orders exist
    }
  }
  
  Future<void> updateOrderRecords(int noofOrders, double totalAmount, int days) async {
    // Get current date in DDMMYYYY format
    DateTime now = DateTime.now();
    String date = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
  //'04032025';// 
    try {
      // Open the SQLite database
      final db = await instance.database;

        await db.transaction((txn) async {
        // Delete records older than $days days
        await txn.rawDelete('''
          DELETE FROM orderRecords 
          WHERE CAST(SUBSTR(date, 5, 4) || SUBSTR(date, 3, 2) || SUBSTR(date, 1, 2) AS INTEGER) 
          <= CAST(strftime('%Y%m%d', 'now', '-$days days') AS INTEGER)
        ''');

        // Use INSERT OR REPLACE to update the record efficiently
        await txn.rawInsert('''
          INSERT INTO orderRecords (date, noofOrders, total)
          VALUES (?, ?, ?)
          ON CONFLICT(date) 
          DO UPDATE SET 
            noofOrders = orderRecords.noofOrders + excluded.noofOrders,
            total = orderRecords.total + excluded.total
        ''', [date, noofOrders, totalAmount]);
      });

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Separate function to delete orders older than 3 days
  Future<void> _deleteOldOrders(Database db, int days) async {
  // print("Delete orders older than $days days hit");

  await db.transaction((txn) async {
    await txn.rawDelete(
      """
      DELETE FROM orderTrn 
      WHERE orderId IN (
        SELECT id FROM orderMst 
        WHERE SUBSTR(createdAt, 1, 10) <= DATE('now', '-$days days')
      )
      """
    );

    await txn.rawDelete(
      "DELETE FROM orderMst WHERE SUBSTR(createdAt, 1, 10) <= DATE('now', '-$days days')"
    );
  });
}
  
  // Get getOrderRecords
  Future<List<Map<String, dynamic>>> getAllOrderRecords() async {
    // Open the SQLite database
    final db = await instance.database;
     // Fetch all records
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM orderRecords ORDER BY date DESC',
      );
    return result;
  }


  // Get settings
  Future<Map<String, dynamic>?> getSingleAppSetting() async {
    // Open the SQLite database
    final db = await instance.database;

    // Fetch all settings
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
  Future<void> updateSentOrders(List<dynamic> acknowledgments) async {
    final db = await instance.database;

    for (var ack in acknowledgments) {
      final String orderId = ack['orderId']; // Extract orderId

      await db.update(
        'orderMst',
        {'isSent': 1}, // Update isSent to 1
        where: 'id = ?', 
        whereArgs: [orderId], 
      );
    }
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

  //Get Products count
  Future<int> getProductCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM productMst'));
    return count ?? 0;
  }

  //Get Products Packing Price count
  Future<int> getProductPPCount() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ProductPackingPrice'));
    return count ?? 0;
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
    // print("order: ${order.cashCustomerName}: ${order.cashPhoneNumber}");
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
    // print('Data added: $name');
  }

  Future readAllData({name}) async {
    final db = await instance.database;
    // final db = await database;
    // final productMst = await db.query("orderMst");
    final orderTrn = await db.query("orderRecords");
    // final userMst =  await db.query("userMst");
    // final categoryMst =  await db.query("categoryMst");
    // final settings =  await db.query("settings");
    // log("productMst $productMst");
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
      // print("filename $fileName");
      // print("path $path");
      // Clear the instance and reinitialize
      _database = null;
      // await _initDB(fileName);

      // print("Database has been reset successfully.");
    } catch (e) {
      // print("Error resetting database: $e");
    }
  }

  // Example function to delete all categories
  Future<void> deleteAllCategories() async {
    final db = await database;
    await db.delete('categoryMst');
  }

   Future<void> deleteAllProducts() async {
    final db = await database;
    await db.delete('ProductMst');
  }
   Future<void> deleteAllProductsPP() async {
    final db = await database;
    await db.delete('ProductPackingPrice');
  }

  // Delete single order
  Future<void> deleteOrder(String orderId) async {
    final db = await instance.database;
    await db.delete(
      'orderMst',
      where: 'id = ?',
      whereArgs: [orderId],
    );
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
