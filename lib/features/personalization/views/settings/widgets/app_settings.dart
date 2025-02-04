import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/texts/section_heading.dart';
import 'package:easyapp/features/personalization/controllers/settings_controller.dart';
import 'package:easyapp/features/personalization/views/profile/widgets/profile_menu.dart';
import 'package:easyapp/features/personalization/views/settings/widgets/add_app_settings.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/constants/text_strings.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;    

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MColors.primary,
        onPressed: () => Get.to(() => const AddAppSettingsScreen()),
        child: const Icon(Iconsax.add, color: MColors.white),
      ),
      appBar: MAppBar(
          title: Text('App Settings',
              style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true),
      body: Obx(() {
        // Check if the data is being loaded or is empty
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if data is available
        if (controller.setting.value == null) {
          return const Center(
            child: Text(
              'No Settings Found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Show the data if available
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MSizes.defaultSpace),
            child: Column(
              children: [
                //Profile Information Details
                const SizedBox(height: MSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: MSizes.spaceBtwItems),
                const MSectionHeading(
                    title: MTexts.appSettings, showActionButton: false),
                const SizedBox(height: MSizes.spaceBtwItems),
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
                  title: 'App Key :',
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
                    title: 'API URL :',
                  icon: Iconsax.copy,
                    value: controller.setting.value.apiUrl),

                // MProfileMenu(
                //     onPressed: () {},
                //     title: 'Doc Series',
                //     showIcon: false,
                //     value: controller.setting.value.docSeries),

                MProfileMenu(
                    onPressed: () {},
                    title: 'Location :',
                    showIcon: false,
                    value: controller.setting.value.locationId.toString()),

                MProfileMenu(
                    onPressed: () {},
                    title: 'Default Customer :',
                    showIcon: false,
                    value: controller.setting.value.defaultCustomer.toString()),
              ],
            ),
          ),
        );
      }),
    );
  }
}
