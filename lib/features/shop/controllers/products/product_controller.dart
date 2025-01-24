import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/features/shop/controllers/products/favourites_controller.dart';
import 'package:multiapp/utils/popups/loaders.dart';

import '../../models/product_model.dart';
import 'dart:developer';
class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  final isLoading = false.obs;
  // final isRetailPrice = false.obs;
  final productName= TextEditingController();
  RxList<ProductModels> featuredProducts = <ProductModels>[].obs;
  RxList<ProductModels> allFeaturedProducts = <ProductModels>[].obs;
  final RxBool refreshSignal = false.obs; // Signal to refresh data
  final favController = Get.put(FavouritesController());
  var searchResults = [].obs; // Observable to hold search results

  @override
  void onInit() {
    fetchFeaturedProducts();
    // isRetailPricePricing();
    debounce(refreshSignal, (_) => fetchFeaturedProducts(), time: const Duration(milliseconds: 300)); 
    // debounce avoids frequent updates in case of multiple API calls.
    super.onInit();
  }

//Fetch products
Future<void> fetchFeaturedProducts() async {
  try {
    //Show loader while loading products
    isLoading.value = true;
    // Start by fetching data from the database
    final snapshot = await db.getProducts();
    // log('snapshot products: $snapshot');

    // Handle null or empty result (no categories found)
    if (snapshot == null || snapshot.isEmpty) {
      return;
    }

    // Map each product from the snapshot (SQLite result) to productModel
    final allProducts = snapshot.map((data) {
      // Ensure correct type casting
      return ProductModels.fromMap(data);
    }).toList();
    // log('Fetched products: $allPoducts');
    final favProductId = favController.favourites;
    
    // Sort all products by favorite status
    final sortedProducts = allProducts.toList()
      ..sort((a, b) {
        final aIsFav = favProductId[a.itmCode] == true;
        final bIsFav = favProductId[b.itmCode] == true;
        if (aIsFav && !bIsFav) return -1; // Favorites come first
        if (!aIsFav && bIsFav) return 1;  // Non-favorites go after
        return 0; // Maintain relative order otherwise
      });

    // Assign the sorted products to featuredProducts, taking only the first 8
    featuredProducts.assignAll(
      sortedProducts.take(12).toList(),
    );
    
  } catch (e) {
    // Handle and show error message
    MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  } finally {
    // Remove loader or stop any loading indicator
    isLoading.value = false;
  }
}

Future<void> fetchSearchProduct(String keyWord) async {
  try {
    // Log the search keyword
    // log('Search keyword: $keyWord');

    // Fetch data from the database
    final snapshot = await db.getProductSearch('%$keyWord%');
    // log('Snapshot: $snapshot');

    if (snapshot == null || snapshot.isEmpty) {
      // Clear and notify user if no results are found
      featuredProducts.clear();
      // MLoaders.warningSnackBar(title: 'No Results', message: 'No products found.');
      return;
    }

    // Map each product from the snapshot to ProductModels
    final allProducts = snapshot.map<ProductModels>((data) {
      try {
        return ProductModels.fromMap(data);
      } catch (e) {
        rethrow;
      }
    }).toList();

    // log('Fetched products: $allProducts');

    // Get favorite product IDs from the controller
    final favProductId = favController.favourites;

    // Sort all products by favorite status, with favorites first
    final sortedProducts = allProducts.toList()
      ..sort((a, b) {
        final aIsFav = favProductId[a.itmCode] == true;
        final bIsFav = favProductId[b.itmCode] == true;
        if (aIsFav && !bIsFav) return -1; // Favorites come first
        if (!aIsFav && bIsFav) return 1;  // Non-favorites go after
        return a.longName.compareTo(b.longName); // Alphabetical tiebreaker
      });

    // Assign the sorted products to featuredProducts (limit to 12)
    final topProducts = sortedProducts.take(12).toList();
    if (!areListsEqual(featuredProducts.toList(), topProducts)) {
      featuredProducts.assignAll(topProducts);
    }
  } catch (e) {
    // Handle and log errors
    // log('Error in fetchSearchProduct: $e');
    MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  }
}

bool areListsEqual(List<ProductModels> list1, List<ProductModels> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].itmCode != list2[i].itmCode) return false;
  }
  return true;
}

String getProductPrice(ProductModels product) {
  double smallestPrice = double.infinity;
  double largestPrice = 0.0;
  double pWspIncVat = product.wspIncVat;
  double pRspIncVat = product.rspIncVat;
  String fixUnitOfSell = product.fixUnitOfSell ?? '';
  double pQspIncVat = 0.0;
  AuthenticationRepository.instance.isQuantityPrice.value =true;
  

  // Case 1: return quantity price range if set default 
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice;
  // print("isQuantityPrice prod: ${isQuantityPrice}");
  if (isQuantityPrice.value) {
    for (var packing in product.quantityPrice!) {
      //Get the fixUnitOfSell & compare with the current base pack quantity
      if (fixUnitOfSell == packing.bulkPackUnit){
        pQspIncVat = packing.bulkPackUPrice?.toDouble() ?? 0.0; // Quantity price logic
        // print("product ${product.itmCode}: bulkPackUnit = $fixUnitOfSell, bulkPackUPrice = $pQspIncVat");
      }
    }
    return (pQspIncVat > 0 ? pQspIncVat : pRspIncVat).toStringAsFixed(0); 
  }


  // Case 2: If no quantity prices or only one, return the default price
  if (product.quantityPrice == null || product.quantityPrice!.length <= 1) {
    return (pWspIncVat > 0 ? pWspIncVat : pRspIncVat).toStringAsFixed(0);
  }
  

  // Case 3: Multiple quantity prices exist
  if (product.quantityPrice != null && product.quantityPrice!.isNotEmpty) {
    for (var packing in product.quantityPrice!) {
      double priceToConsider;
      final isRetailPrice = AuthenticationRepository.instance.isRetailPrice;
    
      // Check if retail price is the default
      if (isRetailPrice.value) {
        double productQty = packing.basePackQty?.toDouble() ?? 0.0;
        priceToConsider = productQty * pRspIncVat; // Retail price logic
        // print("Product ${product.itmCode}: base qty = $productQty, rspIncVat = $pRspIncVat, total = $priceToConsider");
      } else {
        priceToConsider = packing.bulkPackUPrice?.toDouble() ?? 0.0; // Wholesale price logic
      }

      // Update smallest and largest prices
      if (priceToConsider < smallestPrice) {
        smallestPrice = priceToConsider;
      }
      if (priceToConsider > largestPrice) {
        largestPrice = priceToConsider;
      }
    }

    // If smallest and largest prices are approximately the same, return a single price
    if ((smallestPrice - largestPrice).abs() < 0.01) {
      return largestPrice.toStringAsFixed(0); // Single price with no decimals
    } else {
      // Otherwise, return a price range with no decimals
      return '${smallestPrice.toStringAsFixed(0)} - ${largestPrice.toStringAsFixed(0)}';
    }
  }
  
  // Fallback case: Return base price if no variations exist
  return (product.wspIncVat > 0
          ? product.wspIncVat.toStringAsFixed(0)
          : product.rspIncVat.toStringAsFixed(0))
      .toString();
}


  // Set default selling price
  // void isRetailPricePricing() async {
  //   try {
  //     // Fetch the default price setting from the database
  //     final setting = await db.getSingleAppSetting();

  //     // Check if the setting exists and contains the 'IsRSP' field
  //     final isRsp = setting?['IsRSP'] ?? 0; // Default to 0 if null

  //     // Update the observable value based on the 'IsRSP' field
  //     isRetailPrice.value = (isRsp == 1); // Assume 1 indicates true (retail price)

  //   } catch (e) {
  //     // Show an error if anything goes wrong
  //     MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //   }
  // }


  //Check product stock status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}