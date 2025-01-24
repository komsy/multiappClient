import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/personalization/models/Setting_model.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/popups/full_screen_loader.dart';
import 'package:multiapp/utils/popups/loaders.dart';
import 'dart:developer'; 

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  final isLoading = false.obs;
  final isRetailPrice = false.obs;
  Rx<SettingModel> setting =SettingModel.empty().obs; //Observable settting
  final apiUrl = TextEditingController();
  final defaultCustomer = TextEditingController();
  final apiKey = TextEditingController();
  final docSeries = TextEditingController();
  GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    fetchSettings();
    super.onInit();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      // Fetch the first setting from the database
      final snapshot = await db.getSingleAppSetting();
      
      // Handle null or empty result
      if (snapshot == null || snapshot.isEmpty) {
        setting(null); // Assign null if no settings are found
        return;
      }
      // Map the snapshot to a SettingModel instance
      final settings = SettingModel.fromMap(snapshot);

      // Assign the setting instance
      setting(settings);
    } catch (e) {
      // Display an error message
      MLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      setting(null); // Handle errors by assigning null
    } finally {
      // Remove loader or stop any loading indicator
      isLoading.value = false;
    }
  }

    
  Future addNewAppSettings() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog('Storing App Settings...', MImages.docerAnimation);

      //Form validation
      if(!settingsFormKey.currentState!.validate()){
        MFullScreenLoader.stopLoading();
        return;
      }
      log("setting ${setting.value.isRSP}" );
      //Update user's first & last name in the sqlite firestore
      final settings = SettingModel(
        appKey: AuthenticationRepository.instance.appKey.value,
        apiKey: apiKey.text.trim(),
        defaultCustomer: defaultCustomer.text.trim(),
        apiUrl: apiUrl.text.trim(),
        docSeries: docSeries.text.trim() ,
        docNo:setting.value.docNo,
        isRSP:AuthenticationRepository.instance.isRetailPrice.value ? 1: 0,
        createdAt: DateTime.now().toIso8601String(),
      );
      // print("Setting saving data ${settings.apiKey}, ${settings.apiUrl}, ${settings.docSeries}, ${settings.toJson()}");

      await db.saveAppSettings(settings);

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      // MLoaders.successSnackBar(title: 'Congratulations', message: 'Your App settings has been saved successfully.');
    
      //Reset fields
      resetFormFields();
      //Reload the settings
      fetchSettings();
      //Redirect 
      // Get.off(() => const NavigationMenu());
      // Navigator.of(Get.context!).pop();
      AuthenticationRepository.instance.logout();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'App Setting not found', message: e.toString());
    }
  }
 
  Future updateDefaultPricing() async {
    try {
      
    // Fetch the current settings
    // final currentSetting = await db.getSingleAppSetting();
    // if (currentSetting == null) {
    //   throw Exception("App Setting not found!");
    // }

    // Toggle the `isRSP` value and prepare updated settings
    // final updatedSettings = SettingModel(
    //   appKey: currentSetting['appKey'],
    //   apiKey: currentSetting['APIKey'],
    //   defaultCustomer: currentSetting['defaultCustomer'],
    //   apiUrl: currentSetting['APIURL'],
    //   docSeries: currentSetting['docSeries'],
    //   docNo: currentSetting['docNo'],
    //   isRSP: currentSetting['IsRSP'] == 1 ? 0 : 1, // Toggle between 1 and 0
    //   createdAt: DateTime.now().toIso8601String(),
    // );

    // Save updated settings in the database
      // await db.saveAppSettings(updatedSettings);
      final isRSP = !AuthenticationRepository.instance.isRetailPrice.value;  //currentSetting['IsRSP'] == 1 ? 0 : 1;
      final rowsUpdated = await db.updateAppSettings(isRSP);


    //Clear the cart to prevent incorrect prices
    // CartController.instance.clearCart();
    // Toggle the in-memory observable value
    AuthenticationRepository.instance.isRetailPrice.value = isRSP;
    // Notify the controller to refresh
    ProductController.instance.refreshSignal.value = true;
    // Reinitialize the ProductController
    // Get.delete<ProductController>(); // Remove the current instance
    // Get.put(ProductController());   // Recreate the controller
    
    //Show success message
    
    if (rowsUpdated > 0) {
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Default price changed successfully.');
    } else {
      MLoaders.errorSnackBar(title: 'Error', message: 'Failed to change the default Price. Please try again later.');
    }
    } catch (e) {
      //Show some generic error to the user
      MLoaders.errorSnackBar(title: 'App Setting not found', message: e.toString());
    }
  }
  //Fn to reset form fields
  void resetFormFields() {
    apiUrl.clear();
    apiKey.clear();
    docSeries.clear();
    settingsFormKey.currentState?.reset();
  }


}