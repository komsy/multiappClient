// import 'dart:math';

import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/provider/api_provider.dart';
import 'package:multiapp/env.dart';
import 'package:multiapp/features/shop/controllers/customer_controller.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/models/customer_model.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/features/shop/models/product_packing_price.dart';
import 'package:multiapp/features/shop/models/product_unit_converter.dart';
import 'dart:developer';

import 'package:multiapp/utils/popups/loaders.dart';

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
  List<ProductModels> products = [];
  // List<ProductUnitConverter> packagingDetail = [];
  List<ProductPackingPrice> quantityPrice = [];
  RxInt noOfProductItems = 0.obs;
  RxInt noOfUnitCItems = 0.obs;
  RxInt noOfPPItems = 0.obs;
  RxInt noOfCategoryItems = 0.obs;
  RxInt noOfCustomerItems = 0.obs;

  //Get products from api and store
  Future<void> fetchAndStoreProducts() async {
    try {
    //Show loader while loading products
      isProductLoading.value = true;
      isCatLoading.value = false;
      isCustLoading.value = false;
      isPPLoading.value = false;
      isUnitCLoading.value = false;
      // Fetch the data from the API
      List<dynamic> apiProducts = await apiProvider.getAPIData(Env.productApiUrl);
      
      noOfProductItems.value = apiProducts.length;
      print('api products: $apiProducts');

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
        // Acknowledge each product after insertion
        await acknowledgeProductData(product);
    
      }
      // ProductController.instance;
      MLoaders.successSnackBar(title: 'Products Loaded!', message:'Products Successfully loaded');
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

    // Fetch the data from the API
    List<dynamic> apiProductUnit = await apiProvider.getAPIData(Env.unitApiUrl);
    noOfUnitCItems.value = apiProductUnit.length;

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
      MLoaders.successSnackBar(title: 'ProductUnitConverter Loaded!', message:'ProductUnitConverter Successfully loaded');
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
      // Notify the controller to refresh
      ProductController.instance.refreshSignal.value = false;
    
      // Fetch the data from the API
      List<dynamic> apiProductPackaging = await apiProvider.getAPIData(Env.packagingApiUrl);
      noOfPPItems.value = apiProductPackaging.length;
      
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
      MLoaders.successSnackBar(title: 'ProductPackingPrice Loaded!', message:'ProductPackingPrice Successfully loaded');
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

      // Fetch the data from the API
      List<dynamic> apiCustomer = await apiProvider.getAPIData(Env.customerApiUrl);
      noOfCustomerItems.value = apiCustomer.length;
      
      // log('api customers: $apiCustomer');

      // Truncate the customer table before inserting new data, if needed
      await db.truncateCustomerMst();
 
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
        await acknowledgeCustomerData(customer);
      }
      MLoaders.successSnackBar(title: 'Customers Loaded!', message:'Customers Successfully loaded');
      // Notify the controller to refresh
      CustomerController.instance.refreshSignal.value = true;
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      // print('Error ack customer data: $e');
    } finally {
      // Remove loader or stop any loading indicator
      isCustLoading.value = false;
    }
  }

  Future<void> acknowledgeCustomerData(CustomerModel customer) async {
    try {
      // Fetch the data from the API
      final ackCustomerData = await apiProvider.acknowledgeCustomerData(Env.ackCustomerApiUrl,customer);
      
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
      final  ackProductData = await apiProvider.acknowledgeProductData(Env.ackProductApiUrl,product);
      
       // Display the success message in a snack bar
      // MLoaders.successSnackBar(title: 'Customer Updated!', message: ackProductData['message'] ?? 'Operation successful');

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap here!', message: e.toString());
    }
  }


Future<void> fetchAndSendOrders() async 
  {
    try {
      //Show loader while loading Customers
      isSendLoading.value = true;

      // Fetch the data from the API
      final apiOrders = await apiProvider.sendOrders("saveOrders");
      log('api Orders: ${apiOrders['code']}');

      //if order status is 200, truncate the order table before inserting new data, if needed
      if (apiOrders['code'] == 200) {
        await db.truncateOrderMst();
      }

      MLoaders.successSnackBar(title: 'Orders Loaded!', message: apiOrders['message']  ?? 'Orders Sent Successfully.');
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      // print('Error ack customer data: $e');
    } finally {
      // Remove loader or stop any loading indicator
      isSendLoading.value = false;
    }
  }
}
