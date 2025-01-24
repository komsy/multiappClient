import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/SQLite/sqlite.dart';
import 'package:multiapp/common/widgets/loaders/circular_loader.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/shop/models/credit_customer_model.dart';
import 'package:multiapp/features/shop/screens/customer/widgets/single_credit_customer.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/cloud_helper_functions.dart';
import 'package:multiapp/utils/popups/full_screen_loader.dart';
import 'package:multiapp/utils/popups/loaders.dart';
import 'dart:developer';
import 'dart:async';

import 'package:multiapp/utils/validators/validation.dart';

class CreditCustomerController extends GetxController {
  static CreditCustomerController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  //Form for credit customer
  final customerName = TextEditingController();
  final phoneNumber = TextEditingController();
  final pinNo = TextEditingController();
  final address = TextEditingController();
  GlobalKey<FormState> creditFormKey = GlobalKey<FormState>();
  final Rx<CreditCustomerModel> selectedCrClient =
      CreditCustomerModel.empty().obs;
  RxBool refreshData = true.obs;

  @override
  void onInit() {
    fetchCashCustomers();
    super.onInit();
  }

  Future<List<CreditCustomerModel>> fetchCashCustomers() async {
    try {
      List<Map<String, dynamic>> snapshot;

      snapshot = await db.getCreditCustomer();

      // log('Search snapshot: $snapshot');
      // Handle null or empty result
      if (snapshot.isEmpty) {
        return [];
      }

      // Map each customer from the snapshot to a CreditCustomerModel instance
      final allCreditCustomers = snapshot.map((data) {
        return CreditCustomerModel.fromMap(data);
      }).toList();

      // Set the selectedCustomer based on company name with error handling
      selectedCrClient.value = allCreditCustomers.firstWhere(
        (customer) => customer.selectedCrCustomer == 1,
        orElse: () =>
            CreditCustomerModel.empty(), // Provide a default empty customer
      );

      return allCreditCustomers;
    } catch (e) {
      MLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  //Add Cash Customer
  Future<dynamic> createCreditCustomer(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            // padding: MediaQuery.of(context).viewInsets,
            padding: const EdgeInsets.all(MSizes.lg)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MSectionHeading(
                      title: 'Create New Cash Customer',
                      showActionButton: false),
                  const SizedBox(height: MSizes.spaceBtwSections),
                  Form(
                    key: creditFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: customerName,
                            validator: (value) => MValidator.validateEmptyText(
                                'Customer Name', value),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.user),
                                labelText: 'Customer Name')),
                        const SizedBox(height: MSizes.spaceBtwInputFields),
                        TextFormField(
                            controller: phoneNumber,
                            validator: (value) =>
                                MValidator.validatePhoneNumber(value),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.mobile),
                                labelText: 'PhoneNumber')),
                        const SizedBox(height: MSizes.spaceBtwInputFields),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    controller: pinNo,
                                    validator: (value) =>
                                        MValidator.validatePinNo(value),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Iconsax.building_31),
                                        labelText: 'Pin No'))),
                            const SizedBox(width: MSizes.spaceBtwInputFields),
                            Expanded(
                                child: TextFormField(
                                    controller: address,
                                    validator: (value) =>
                                        MValidator.validateEmptyText(
                                            'Address', value),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Iconsax.code),
                                        labelText: 'Address'))),
                          ],
                        ),
                        const SizedBox(height: MSizes.defaultSpace),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => addNewCreditCustomer(),
                                child: const Text('Save'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future addNewCreditCustomer() async {
    try {
      //Start loading
      MFullScreenLoader.openLoadingDialog(
          'Storing Cash Customer...', MImages.docerAnimation);

      print("cr customer ${creditFormKey.currentState}");
      //Form validation
      // if (creditFormKey.currentState?.validate() ?? false) {
      //   MFullScreenLoader.stopLoading();
      //   return;
      // }
      //Save credit client to Db
      final customer = CreditCustomerModel(
          customerName: customerName.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          pinNo: pinNo.text.trim(),
          address: address.text.trim(),
          selectedCrCustomer: 1);

      print("cr customer ${customer.pinNo}");
      await db.saveSelectedCrClient(customer);
      await selectedCrClient(customer);

      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show success message
      MLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your Cash Customer has been saved successfully.');

      //Reset fields
      resetFormFields();

      //Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //Remove loader
      MFullScreenLoader.stopLoading();

      //Show some generic error to the user
      MLoaders.errorSnackBar(
          title: 'Cash Customer not fopund', message: e.toString());
    }
  }

  //Fn to reset form fields
  void resetFormFields() {
    customerName.clear();
    phoneNumber.clear();
    pinNo.clear();
    address.clear();
    creditFormKey.currentState?.reset();
  }

  //Show CUSTOMER modalBottomSheet at checkout
  Future<dynamic> selectNewCrCustomerPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(MSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MSectionHeading(
                title: "Select Cash Customer", showActionButton: false),
            const SizedBox(height: MSizes.spaceBtwSections),

            // FutureBuilder to fetch the Cash customers
            FutureBuilder(
              future: fetchCashCustomers(), // Fetching Cash customers
              builder: (_, snapshot) {
                // Handle different states of the future (loading, error, or data)
                final response = MCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot);
                if (response != null)
                  return response; // Returns a loading or error widget

                // If the data is available and the response is null, build the list view
                return Expanded(
                  // Wrapping ListView inside an Expanded to avoid unbounded height error
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => MSingleCrCustomer(
                        crCustomer: snapshot.data![index],
                        onTap: () async {
                          await selectCrClient(snapshot.data![index]);
                          Get.back(); // Close the modal after selecting the customer
                        }),
                  ),
                );
              },
            ),

            // Add New Address Button (Optional, you can uncomment and implement this part)
            // const SizedBox(height: MSizes.defaultSpace * 2),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () => Get.to(() => AddNewAddressPage()),
            //     child: const Text('Add New Address')
            //   )
            // )
          ],
        ),
      ),
    );
  }

  Future selectCrClient(CreditCustomerModel newSelectedCrClient) async {
    try {
      Get.defaultDialog(
          title: '',
          onWillPop: () async {
            return false;
          },
          barrierDismissible: false,
          backgroundColor: Colors.transparent,
          content: const MCircularLoader());

      //Clear the "selected" field
      // if(selectedCrClient.value.customerName.isNotEmpty){
      //   await db.updateSelectedField(selectedCrClient.value.customerName, 0);
      // }
      await clearCashCustomer(); // Clear the cash customer details from db and observable if any exists.

      //Assign selected CrClient
      newSelectedCrClient.selectedCrCustomer = 1;
      selectedCrClient.value = newSelectedCrClient;

      //Set the "selected" field to true for the newly selected CrClient
      await db.updateSelectedField(selectedCrClient.value.customerName, 1);
      Get.back();
    } catch (e) {
      MLoaders.errorSnackBar(
          title: 'Error in Selection', message: e.toString());
    }
  }

  Future clearCashCustomer() async {
    try {
      // Clear the selected credit customer details from db and observable
      if (selectedCrClient.value.customerName.isNotEmpty) {
        await db.updateSelectedField(selectedCrClient.value.customerName, 0);
      }
      selectedCrClient.value = CreditCustomerModel.empty();
    } catch (e) {
      MLoaders.errorSnackBar(
          title: 'Error in Selection', message: e.toString());
    }
  }
}
