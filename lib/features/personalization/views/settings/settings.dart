import 'package:easyapp/features/personalization/controllers/update_controller.dart';
import 'package:easyapp/features/personalization/controllers/user_controller.dart';
import 'package:easyapp/features/personalization/views/location/location.dart';
import 'package:easyapp/features/shop/screens/order/widgets/order_records_pie_chart.dart';
import 'package:easyapp/utils/constants/text_strings.dart';
import 'package:easyapp/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:easyapp/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:easyapp/common/widgets/texts/section_heading.dart';
import 'package:easyapp/data/services/API/api_services.dart';
import 'package:easyapp/features/personalization/controllers/settings_controller.dart';
import 'package:easyapp/features/personalization/views/settings/widgets/app_settings.dart';
import 'package:easyapp/features/shop/screens/cart/cart.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../profile/widgets/load_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.put(MAPIService()); 
    Get.put(SettingsController());
    Get.put(UpdateController());
    final controller = UserController.instance;
    final authRepo = AuthenticationRepository.instance;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          //Header 
          MPrimaryHeaderContainer(
            child: Column(
              children: [
                MAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: MColors.white)),
                actions: [
                  IconButton(
                    onPressed: () => AuthenticationRepository.instance.logout(),
                    icon: const Icon(Iconsax.logout, color: MColors.white, size: MSizes.iconMd * 1.2),
                  )
                ],),

                //User profile card
                const MUserProfileTile(),
                const SizedBox(height: MSizes.spaceBtwSections),
              ],
            )
            ),

          //Body
          Transform.translate(
            offset: const Offset(0, -20), 
            child: Padding(
              padding: const EdgeInsets.all(MSizes.defaultSpace),
              child: Column(
                children: [
                  //Account Setting
                  const MSectionHeading(title: 'App Setting', showActionButton: false),
                  const SizedBox(height: MSizes.spaceBtwItems/2),
            
                  MSettingsMenuTile(icon: Iconsax.shopping_cart, title: "My Cart", subTitle: "Add & Remove Products", onTap: () => Get.to(() => const CartScreen()) ),
                  MSettingsMenuTile(icon: Iconsax.shop, title: "My Orders", subTitle: "View ${authRepo.orderRecordDays.value} days Order Records", onTap: () => Get.to(() => const MOrderRecordsPieChart()) ),
                  MSettingsMenuTile(icon: Iconsax.setting, title: "Settings", subTitle: "Set App Configs", 
                  onTap: () =>Get.to(() => const AppSettingsScreen())),
                  
                  // MSettingsMenuTile(
                  //     icon: Iconsax.money,
                  //     title: "Pricing",
                  //     subTitle: "Toogle between WholeSale & Retail Price",
                  //     trailing: Obx(() => Switch(
                  //           value: AuthenticationRepository.instance.isRetailPrice.value,
                  //           onChanged: (value) {
                  //             controller.updateDefaultPricing();
                  //           },
                  //         )),
                  //   ),
                  //App Setting
                  // const SizedBox(height: MSizes.spaceBtwSections/2),
                  // const MSectionHeading(title: 'App Settings', showActionButton: false),
                  // const SizedBox(height: MSizes.spaceBtwItems/2),
                  MSettingsMenuTile(icon: Iconsax.document_download, title: "Load Data", subTitle: "Add Products & Customers", onTap: () => Get.to(() => const LoadDataScreen())),
                  
                  MSettingsMenuTile(icon: Iconsax.location, title: "Location Data", subTitle: "Show my Location data", onTap: () => Get.to(() => const MLocation())),
                  
                  MSettingsMenuTile(
                        icon: Iconsax.document_upload,
                        title: "Send Order",
                        subTitle: "Send Orders to Server",
                        onTap: () => {},
                        trailing: Obx(() {
                          return IconButton(
                              onPressed: apiService.isSendLoading.value
                                  ? null // Disable the button while loading
                                  : () => apiService.fetchAndSendOrders(),
                              icon: apiService.isSendLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 2,
                                    )
                                  : const Icon(
                                      Icons.cloud_upload,
                                      color: Colors.orange,
                                    ),
                            );
                          }),
                        ),
                  
                  
                  MSettingsMenuTile(
                    icon: Iconsax.support, 
                    title: "Contact Support",
                    subTitle: "Tap to Call or Email for Support", 
                    trailing: IconButton(
                          onPressed: () async {
                            String? encodeQueryParameters(
                              Map<String, String> params) {
                                return params.entries
                                    .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                    .join('&');
                              }
                            
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto', 
                              path: authRepo.supportEmail.toString(),
                              query: encodeQueryParameters(<String, String>{
                                'subject': 'Support Request',
                                'body': 'Hello, I need help with...',
                              }),
                            );
                            
                            try {
                              // Attempt to launch the email app
                              await launchUrl(emailLaunchUri);
                            } catch (e) {
                              // Handle any errors that occur during the launch
                              MLoaders.errorSnackBar(title: 'Could not launch email app', message: e.toString());
                            } 
                          },
                          icon:  const Icon(Icons.email,color: Colors.orange),
                        ),
                    onTap: () {
                      final Uri phoneLaunchUri = Uri(
                        scheme: 'tel',
                        path: authRepo.supportPhone.toString(),
                      );
                      try {
                        // Attempt to launch the phone dialer
                        launchUrl(phoneLaunchUri);
                      } catch (e) {
                        // Handle any errors that occur during the launch
                        MLoaders.errorSnackBar(title: 'Could not launch phone dialer', message: e.toString());
                      } 
                    }
                    ),
            
                  //Logout Button
                  // const SizedBox(height: MSizes.spaceBtwSections),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child:  OutlinedButton(onPressed: () =>AuthenticationRepository.instance.logout(), child: const Text('Logout')),
                  // ),

                  controller.user.value.userName != "admin"
                  ? Column(
                      children: [
                        const SizedBox(height: MSizes.spaceBtwSections *1.5 ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => controller.deleteAccDialog(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.red),
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Delete Account'),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

    
                  const SizedBox(height: MSizes.spaceBtwSections*1.5),
                  Column(
                    children: [
                      Text(MTexts.appVersion, style: Theme.of(context).textTheme.titleMedium!
                                                    .apply(color: MColors.error, fontWeightDelta: 1)),
                    ],
                  ),
                  // const SizedBox(height: MSizes.spaceBtwSections)
                ],
              ),
              ),
          ),
          ],
        ),
      ),
    );
   
  }
}

