import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/texts/section_heading.dart';
import 'package:easyapp/features/personalization/controllers/settings_controller.dart';
import 'package:easyapp/features/personalization/views/profile/widgets/profile_menu.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/constants/text_strings.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;    

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MColors.primary,
      //   onPressed: () => Get.to(() => const AddAppSettingsScreen()),
      //   child: const Icon(Iconsax.add, color: MColors.white),
      // ),
      appBar: const MAppBar(title: Text('App Settings'),showBackArrow: true,centerTitle: true),
          
      body: Obx(() {
        // Check if the data is being loaded or is empty
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show the data if available
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: Column(
              children: [
                //Profile Information Details
                // const SizedBox(height: MSizes.spaceBtwItems),
                // const MSectionHeading(
                //     title: MTexts.appSettings, showActionButton: false),
                // const Divider(thickness: 2, color: Colors.black),
                // const SizedBox(height: MSizes.spaceBtwItems),
                MProfileMenu(
                  onPressed: () {
                    // Copy the app key to the clipboard
                    Clipboard.setData(ClipboardData(text: controller.setting.value.appKey));
                    // Show a snackbar to notify the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('App Key copied successfully!'),
                        duration: Duration(seconds: 1),
                        backgroundColor: MColors.success,
                      ),
                    );
                  },
                  title: 'App Key   :',
                  icon: Iconsax.copy,
                  value: controller.setting.value.appKey,
                ),

                MProfileMenu(
                    onPressed: () {
                    // Copy the app key to the clipboard
                      Clipboard.setData(ClipboardData(text: controller.setting.value.apiUrl));
                      // Show a snackbar to notify the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Api URL copied successfully!'),
                          duration: Duration(seconds: 1),
                          backgroundColor: MColors.success,
                        ),
                      );
                    },
                    title: 'API URL      :',
                    icon: Iconsax.copy,
                    value: controller.setting.value.apiUrl),

                MProfileMenu(
                    onPressed: () {},
                    title: 'Location    :',
                    showIcon: false,
                    value: controller.setting.value.locationId.toString()),

                MProfileMenu(
                    onPressed: () {},
                    title: 'Cust Code :',
                    showIcon: false,
                    value: controller.setting.value.defaultCustCode.toString()),
                MProfileMenu(
                    onPressed: () {},
                    title: 'Def Pricing :',
                    showIcon: false,
                    value: controller.setting.value.defaultPricing.toString()),
                MProfileMenu(
                    onPressed: () {},
                    title: 'Edit Order  :',
                    showIcon: false,
                    value: controller.setting.value.editOrder == 0 ? 'False' : 'True'),
                MProfileMenu(
                    onPressed: () {},
                    title: 'Edit Order After send :',
                    showIcon: false,
                    value: controller.setting.value.editAfter == 0 ? 'False' : 'True'),

                MProfileMenu(
                    onPressed: () {},
                    title: 'Keep Order in App  :',
                    showIcon: false,
                    value: '${controller.setting.value.orderDays.toString()} days'),
                const SizedBox(height: MSizes.spaceBtwSections ),
                //Change name Button
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.createAppSettings(context),
                        child: const Text(MTexts.changeSettings))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
