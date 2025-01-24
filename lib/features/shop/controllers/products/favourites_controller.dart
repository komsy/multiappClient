import 'dart:convert';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/utils/local_storage/storage_utility.dart';
import 'package:multiapp/utils/popups/loaders.dart';

class FavouritesController extends GetxController{
  static FavouritesController get instance => Get.find();
  //Variables
  final favourites = <String, bool>{}.obs;
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    initFavourites();
  }

  //Method to initialize favourites by reading from storage
  void initFavourites() {
    final json = MLocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(storedFavourites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

void toggleFavouriteProduct(String productId) async {
  try {
    if (!favourites.containsKey(productId)) {
      favourites[productId] = true;
      const isFavourite = 1;
      await db.updateFavProduct(isFavourite, productId);
      saveFavouritesToStorage();
      favourites.refresh();
      MLoaders.customToast(message: 'Product has been added to the Favourite List.');
    } else {
      MLocalStorage.instance().removeData(productId);
      favourites.remove(productId);
      const isFavourite = 0;
      await db.updateFavProduct(isFavourite, productId);
      saveFavouritesToStorage();
      favourites.refresh();
      MLoaders.customToast(message: 'Product has been removed from the Favourite List.');
    }
  } catch (e) {
    MLoaders.errorSnackBar(title: 'Error', message: 'Failed to update favourite status.');
  }
}

  
  void saveFavouritesToStorage() {
    final encodedFavourites = json.encode(favourites);
    MLocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  
}