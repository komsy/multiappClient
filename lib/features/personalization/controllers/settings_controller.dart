import 'package:easyapp/common/widgets/texts/section_heading.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/features/personalization/controllers/user_controller.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/features/personalization/models/setting_model.dart';
import 'package:easyapp/features/shop/controllers/products/product_controller.dart';
import 'package:easyapp/utils/constants/image_strings.dart';
import 'package:easyapp/utils/popups/full_screen_loader.dart';
import 'package:easyapp/utils/popups/loaders.dart';

import 'package:iconsax/iconsax.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;
    final userController = UserController.instance;

  //Variables
  final isLoading = false.obs;
  final isRetailPrice = false.obs;
  Rx<SettingModel> setting =SettingModel.empty().obs; //Observable settting
  final apiUrl = TextEditingController();
  final defaultCustCode = TextEditingController();
  final apiKey = TextEditingController();
  final docSeries = TextEditingController();
  final locationId = TextEditingController();
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
      // log("setting ${setting.value.isRSP}" );
      //Update user's first & last name in the sqlite firestore
      final settings = SettingModel(
        appKey: AuthenticationRepository.instance.appKey.value,
        apiKey: apiKey.text.trim(),
        defaultCustCode: setting.value.defaultCustCode,
        apiUrl: apiUrl.text.trim(),
        locationId: setting.value.locationId,
        defaultPricing: setting.value.defaultPricing ,
        routeWiseSell:setting.value.routeWiseSell,
        setDefaultCust:setting.value.setDefaultCust,
        editOrder:setting.value.editOrder,
        editAfter:setting.value.editAfter,
        orderDays:setting.value.orderDays,
        orderRecordDays:setting.value.orderRecordDays,
        isRSP:AuthenticationRepository.instance.isRetailPrice.value ? 1: 0,
        createdAt: DateTime.now().toIso8601String(),
        defaultLocation: setting.value.defaultLocation,       
        prodNumber: setting.value.prodNumber,
        goLive: setting.value.goLive,
        exField1: setting.value.exField1,
        exField2: setting.value.exField2,
        exField3: setting.value.exField3,
      );
      // print("Setting saving data ${settings.apiKey}, ${settings.apiUrl}, ${settings.docSeries}, ${settings.toJson()}");


      await db.saveAppSettings(settings);
      //Clear cart to avoid different pricing
      CartController.instance.clearCart(); 
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
      //check if username is changed redirect or logout
      // if(userController.user.value.userName == "admin"){
      //   MLoaders.warningSnackBar(title: 'Error', message: 'Kindly update your username!');
      //   Get.to(() => const ChangeName());
      // } else {
      //   logout
      // }
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
    //   defaultCustCode: currentSetting['defaultCustCode'],
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

  Future<dynamic> createAppSettings(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            // padding: MediaQuery.of(context).viewInsets,
            padding: const EdgeInsets.all(MSizes.lg)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MSectionHeading(
                      title: 'Set API URL & Key',
                      showActionButton: false),
                  const SizedBox(height: MSizes.spaceBtwSections),
                  Form(
                    key: settingsFormKey,
                    child: Column(
                      children: [
                        TextFormField( 
                            controller: apiUrl,
                            validator: (value) => MValidator.validateEmptyText('API URL', value),
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'API URL')),
                          const SizedBox(height: MSizes.spaceBtwInputFields),
                          TextFormField( 
                            controller: apiKey,
                            validator: (value) => MValidator.validateEmptyText('API Key', value),
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.key), labelText: 'API Key')),
             

                        const SizedBox(height: MSizes.defaultSpace),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => addNewAppSettings(),
                                child: const Text('Submit'))),
                      ],
                    ),
                  ),
                ],
              ),
          );
        });
  }


}