// import 'dart:math';

import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/features/authentication/models/user/user_model.dart';
import 'package:easyapp/features/personalization/controllers/user_controller.dart';
import 'package:easyapp/features/personalization/models/setting_model.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/data/provider/api_provider.dart';
import 'package:easyapp/env.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/features/shop/controllers/products/product_controller.dart';
import 'package:easyapp/features/shop/models/customer_model.dart';
import 'package:easyapp/features/shop/models/product_model.dart';
import 'package:easyapp/features/shop/models/product_packing_price.dart';
import 'package:easyapp/features/shop/models/product_unit_converter.dart';

import 'package:easyapp/utils/popups/loaders.dart';

class MAPIService extends GetxController {
  static MAPIService get instance => Get.find();
  final apiProvider = ApiProvider();
  
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  final isSendLoading = false.obs;
  final isProductLoading = false.obs;
  final isUnitCLoading = false.obs;
  final isPPLoading = false.obs;
  final isCatLoading = false.obs;
  final isCustLoading = false.obs;
  final isSettingsLoading = false.obs;
  List<ProductModels> products = [];
  // List<ProductUnitConverter> packagingDetail = [];
  List<ProductPackingPrice> quantityPrice = [];
  RxInt noOfProductItems = 0.obs;
  RxInt noOfUnitCItems = 0.obs;
  RxInt noOfPPItems = 0.obs;
  RxInt noOfCategoryItems = 0.obs;
  RxInt noOfCustomerItems = 0.obs;
  RxInt noOfSettingItems = 0.obs;
  final authInstance =AuthenticationRepository.instance;
  //Get products from api and store
  Future<void> fetchAndStoreProducts() async {
    try {
    //Show loader while loading products
      isProductLoading.value = true;
      isCatLoading.value = false;
      isCustLoading.value = false;
      isPPLoading.value = false;
      isUnitCLoading.value = false;
      isSettingsLoading.value = false;
      // Fetch the data from the API
      List<dynamic> apiProducts = await apiProvider.getAPIData(Env.productApiUrl);
      
      noOfProductItems.value = apiProducts.length;
      // print('api products: $apiProducts');
      if (apiProducts.isEmpty) {
        throw Exception("No product data found");
      }
      // Truncate the product table before inserting new data, if needed
      // await db.truncateProductTable();

      // Iterate over each product and insert it into the SQLite database
      for (var productData in apiProducts) {
        final product = ProductModels(
          itmCode: productData['ItmCode'],
          locationID: productData['LocationID'],
          godownName: productData['GodownName'],
          longName: productData['LongName'],
          catCode: productData['CatCode'],
          catName: productData['CatName'],
          unit: productData['Unit'],
          fixUnitOfSell: productData['FixUnitOfSell'],
          taxCode : productData['TaxCode'],
          taxRate: productData['TaxRate'],
          isFavourite: "0",
          rspIncVat: productData['RspIncVat'].toDouble(),
          wspIncVat: productData['WspIncVat'].toDouble(),
          currBalance: productData['CurrBalance'],
        );  
        // Insert product into database
        await db.insertAPIProduct(product);
        
        // Acknowledge each product after insertion to API
        // await acknowledgeProductData(product);
    
      }
    
      // ProductController.instance;
      MLoaders.successSnackBar(title: 'Products Loaded!', message:'Products Successfully loaded',duration: 1);
      // await fetchAndStoreProductUnits();
      // Notify the controller to refresh
      ProductController.instance.refreshSignal.value = true;
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }finally {
      // Remove loader or stop any loading indicator
      isProductLoading.value = false;
    }
  }

//Get products from api and store
Future<void> fetchAndStoreProductUnits() async {
  try {
    //Show loader while loading products unit converter
      isUnitCLoading.value = true;
      isPPLoading.value = false;
      isCatLoading.value = false;
      isCustLoading.value = false;
      isProductLoading.value = false;
      isSettingsLoading.value = false;

    // Fetch the data from the API
    List<dynamic> apiProductUnit = await apiProvider.getAPIData(Env.unitApiUrl);
    noOfUnitCItems.value = apiProductUnit.length;
    if (apiProductUnit.isEmpty) {
      throw Exception("No packaging units data found");
    }
    // Truncate the product table before inserting new data, if needed
    // await db.truncateProductUnitTable();

    // Iterate over each product and insert it into the SQLite database
    for (var unitData in apiProductUnit) {
      final product = ProductUnitConverter(
        itmCode: unitData['ItmCode'],
        locationID: unitData['LocationID'],
        bulkPackQty: unitData['BulkPackQty'],
        bulkPackUnit: unitData['BulkPackUnit'],  // Ensure it's converted to double
        basePackQty: unitData['BasePackQty'],  // Ensure it's converted to double
        basePackUnit: unitData['BasePackUnit'],
      );
      
      await db.insertAPIProductUnitC(product);
    }
      MLoaders.successSnackBar(title: 'ProductUnitConverter Loaded!', message:'ProductUnitConverter Successfully loaded',duration: 1);
      // await fetchAndStoreProductpackaging();
      // Notify the controller to refresh
      // ProductController.instance.refreshSignal.value = true;
  } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  }finally {
      // Remove loader or stop any loading indicator
      isUnitCLoading.value = false;
    }
}


//Get products from api and store
  Future<void> fetchAndStoreProductpackaging() async {
    try {
      //Show loader while loading products Packaging Price
      isPPLoading.value = true;
      isCatLoading.value = false;
      isCustLoading.value = false;
      isUnitCLoading.value = false;
      isProductLoading.value = false;    
      isSettingsLoading.value = false;
      // Notify the controller to refresh
      ProductController.instance.refreshSignal.value = false;
    
      // Fetch the data from the API
      List<dynamic> apiProductPackaging = await apiProvider.getAPIData(Env.packagingApiUrl);
      noOfPPItems.value = apiProductPackaging.length;
      
      if (apiProductPackaging.isEmpty) {
        throw Exception("No packaging price data found");
      }
      // print('api product packaging: $apiProducts');

      // Truncate the product table before inserting new data, if needed
      // await db.truncateProductPackagingTable();

      // Iterate over each product and insert it into the SQLite database
      for (var data in apiProductPackaging) {
        final product = ProductPackingPrice(
        itmCode: data['ItmCode'],
        locationID: data['LocationID'],
        scanCode: data['ScanCode'],
        basePackQty: data['BasePackQty'],  // Ensure it's converted to double
        bulkPackUPrice: data['BulkPackUPrice'],  // Ensure it's converted to double
        bulkPackUnit: data['BulkPackUnit'],
        );
        await db.insertAPIProductPP(product);
      }
      
      MLoaders.successSnackBar(title: 'ProductPackingPrice Loaded!', message:'ProductPackingPrice Successfully loaded',duration: 1);
        // await fetchAndStorePCategories();
      // Notify the controller to refresh
      // ProductController.instance.refreshSignal.value = true;
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }finally {
      // Remove loader or stop any loading indicator
      isPPLoading.value = false;
    } 
  }

  // Future<void> fetchAndStorePCategories() async {
  //   try {
  //     //Show loader while loading categories
  //     isCatLoading.value = true;
  //     isPPLoading.value = false;
  //     isCustLoading.value = false;
  //     isUnitCLoading.value = false;
  //     isProductLoading.value = false;    

  //     // Fetch the data from the API
  //     List<dynamic> apiCategorys = await apiProvider.getAPIData(Env.categoryApiUrl);
  //     noOfCategoryItems.value = apiCategorys.length;
      
  //     // print('api category packaging: $apiCategorys');

  //     // Truncate the category table before inserting new data, if needed
  //     await db.truncateCategoryMst();

  //     // Iterate over each category and insert it into the SQLite database
  //     for (var data in apiCategorys) {
  //       final category = CategoryModel(
  //         catCode: data['catCode'],
  //         catName: data['catName'],
  //         locationID: data['locationID'],
  //         image: ''
  //       );
  //       await db.insertAPICategoryMst(category);
  //     }
  //     MLoaders.successSnackBar(title: 'Categories Loaded!', message:'Categories Successfully loaded');
  //     // await fetchAndStoreCustomer();
  //   } catch (e) {
  //     MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //   }finally {
  //     // Remove loader or stop any loading indicator
  //     isCatLoading.value = false;
  //   }
  // }
  Future<void> fetchAndStoreCustomer() async 
  {
    try {
      //Show loader while loading Customers
      isCustLoading.value = true;
      isPPLoading.value = false;
      isCatLoading.value = false;
      isUnitCLoading.value = false;
      isProductLoading.value = false; 
      isSettingsLoading.value = false;   

      // Fetch the data from the API
      List<dynamic> apiCustomer = await apiProvider.getAPIData(Env.customerApiUrl);
      noOfCustomerItems.value = apiCustomer.length;
      
      if (apiCustomer.isEmpty) {
        throw Exception("No customer data found");
      }
      // log('api customers: $apiCustomer');

      // Truncate the customer table before inserting new data, if needed
      // await db.truncateCustomerMst();
 
      // Iterate over each customer and insert it into the SQLite database
      for (var data in apiCustomer) {
        final customer = CustomerModel(
          cusCode: data['CusCode'], 
          accType: data['AccType'],  
          locationID: data['locationID'],
          crLimit: data['Cr_Limit'],
          companyName: data['CompanyName'], 
          currBalance:data['CurrBalance'],
        );
        // Insert customer into database
        await db.insertAPICustomerMst(customer);

        // Acknowledge each customer after insertion
        //await acknowledgeCustomerData(customer);
        
      }
      MLoaders.successSnackBar(title: 'Customers Loaded!', message:'Customers Successfully loaded',duration: 1);
      // Notify the controller to refresh
      await CustomerController.instance.fetchCustomers();
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      // print('Error ack customer data: $e');
    } finally {
      // Remove loader or stop any loading indicator
      isCustLoading.value = false;
    }
  }

  Future<void> fetchAndStoreAppSettings() async 
  {
    try {
      //Show loader while loading Customers
      isSettingsLoading.value = true;
      isCustLoading.value = false;
      isPPLoading.value = false;
      isCatLoading.value = false;
      isUnitCLoading.value = false;
      isProductLoading.value = false;    

      // Fetch the data from the API
      List<dynamic> apiSettings = await apiProvider.getAPIData("getAppSettings");
      noOfSettingItems.value = apiSettings.length;
      // log('api Settingss: $apiSettings');
      if (apiSettings.isEmpty) {
        throw Exception("No Settings data found");
      }

      // Iterate over each Settings and insert it into the SQLite database
      for (var data in apiSettings) {
        final setting = SettingModel(
          appKey: authInstance.appKey.value,
          defaultCustCode: data['defaultCustCode'],
          apiUrl: authInstance.apiURL.value,
          apiKey:authInstance.apiKey.value,
          defaultPricing: data['defaultPricing'],
          routeWiseSell: data['routeWiseSell'],
          locationId: data['locationId'],
          editOrder: data['editOrder'],
          editAfter: data['editAfter'],
          setDefaultCust: data['setDefaultCust'],
          orderRecordDays:data['orderRecordDays'],
          orderDays:data['orderDays'],
          isRSP: authInstance.isRetailPrice.value ? 1: 0,
          createdAt: DateTime.now().toIso8601String(),
        );

      // Toggle the in-memory observable value
      authInstance.defaultPricing.value = data['defaultPricing'];
        // Insert setting into database
        await db.saveAppSettings(setting);
      }
      //Clear cart to avoid different pricing
      CartController.instance.clearCart();
      authInstance.logout();
      // Notify the controller to refresh
      // await  SettingsController.instance.fetchSettings();
      MLoaders.successSnackBar(title: 'Settings Loaded!', message:'Settings Successfully loaded',duration: 1);
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Settings!', message: e.toString());
      // print('Error ack set data: $e');
    } finally {
      // Remove loader or stop any loading indicator
      isSettingsLoading.value = false;
    }
  }

  Future<void> acknowledgeCustomerData(CustomerModel customer) async {
    try {
      // Fetch the data from the API
      await apiProvider.acknowledgeCustomerData(Env.ackCustomerApiUrl,customer);
      
      // Display the success message in a snack bar
      // MLoaders.successSnackBar(title: 'Customer Updated!', message: ackCustomerData['message'] ?? 'Operation successful');

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap here!', message: e.toString());
    }
  }

  //Send ack for products
  Future<void> acknowledgeProductData(ProductModels product) async {
    try {
      // Fetch the data from the API
      await apiProvider.acknowledgeProductData(Env.ackProductApiUrl,product);
      
       // Display the success message in a snack bar
      // MLoaders.successSnackBar(title: 'Customer Updated!', message: ackProductData['message'] ?? 'Operation successful');

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap here!', message: e.toString());
    }
  }


  Future<void> fetchAndSendOrders() async {
    try {
      isSendLoading.value = true;

      // Retrieve user information
      final email = UserController.instance.user.value.email;
      if (email.isEmpty) {
        throw Exception("User email is not available.");
      }

      final result = await db.login(email);
      if (result == null || result.isEmpty) {
        throw Exception("User login information not found.");
      }

      String username = result[0]['username'];

      // Check user status via API
      final checkAppUser = await apiProvider.checkAppUser(username, email);
      

      // Update local user in the database
      final users = UserModel(
        userName: username,
        email: email,
        password: result[0]['password'],
        role: "user",
        status: 1,
        userStatus: checkAppUser['userStatus'] == 1 ? 1 : 0,
        licStatus: checkAppUser['licStatus'] == 1 ? 1 : 0,
        updatedAt: DateTime.now().toIso8601String(),
        createdAt: result[0]['createdAt'],
      );
      await db.insertUser(users); //Update user & Lic status 

      if (checkAppUser['userStatus'] == 0 || checkAppUser['licStatus'] == 0) {
        MLoaders.errorSnackBar(title: 'Authentication Error', message: 'Account locked. Connect to the internet or contact your administrator!');
        await authInstance.logout(); //Logout 
        return;
      }

      // Send orders to the API if user & Lic still Active
      final apiOrders = await apiProvider.sendOrders("saveOrders");
      
      if (apiOrders['code'] == 200 &&  apiOrders['acknowledgments'].isNotEmpty) {
        // await db.truncateOrderMst();
        //Update order acknowledgement
        await db.updateSentOrders(apiOrders['acknowledgments']);

        //update order isSent
        MLoaders.successSnackBar(title: 'Orders Loaded!',message: apiOrders['message'] ?? 'Orders Sent Successfully.');
      }
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isSendLoading.value = false;
    }
  }
}