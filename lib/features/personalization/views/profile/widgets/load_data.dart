import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/list_tiles/downloads_menu_tile.dart';
import 'package:easyapp/common/widgets/texts/section_heading.dart';
import 'package:easyapp/data/services/API/api_services.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:get/get.dart';


class LoadDataScreen extends StatelessWidget {
  const LoadDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = BannerController.instance;
    final apiService = MAPIService.instance;

    return Scaffold(
      appBar:
      const MAppBar(title: Text('Load Product & Customer Data'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MSectionHeading(title: 'Load data in the same order.', showActionButton: false),
              const SizedBox(height: MSizes.spaceBtwItems),
              // Obx(() => MDownloadsMenuTile(
              //   noOfItems: apiService.noOfCategoryItems.value,
              //   icon: Iconsax.bag_tick,
              //   title: "Load Categories",
              //   subTitle: "Click the icon and wait.",
              //   onTap: () {},
              //   trailing: Obx(() {
              //     return IconButton(
              //       onPressed: apiService.isCatLoading.value
              //           ? null // Disable the button while loading
              //           : () => apiService.fetchAndStorePCategories(),
              //       icon: apiService.isCatLoading.value
              //           ? const CircularProgressIndicator(
              //               color: Colors.orange,
              //               strokeWidth: 2,
              //             )
              //           : const Icon(
              //               Icons.cloud_download,
              //               color: Colors.orange,
              //             ),
              //     );
              //   }),
              // ),),
              // Obx(() => MDownloadsMenuTile(
              //     noOfItems: apiService.noOfUnitCItems.value, // Reactively updates with noOfUnitCItems
              //     icon: Iconsax.safe_home,
              //     title: "Load Products Unit Converter",
              //     subTitle: "Click the icon and wait.",
              //     onTap: () {}, // Define the onTap action as needed
              //     trailing: Obx(() { // Reactive state for the trailing button
              //       return IconButton(
              //         onPressed: apiService.isUnitCLoading.value
              //             ? null // Disable the button if loading
              //             : () => apiService.fetchAndStoreProductUnits(), // Trigger function if not loading
              //         icon: apiService.isUnitCLoading.value
              //             ? const CircularProgressIndicator(
              //                 color: Colors.orange,
              //                 strokeWidth: 2,
              //               )
              //             : const Icon(
              //                 Icons.cloud_download,
              //                 color: Colors.orange,
              //               ),
              //       );
              //     }),
              //   )),

              Obx(() => MDownloadsMenuTile(
                noOfItems: apiService.noOfPPItems.value,
                icon: Iconsax.money,
                title: "Load Product Packaging Price",
                subTitle: "Click the icon and wait.",
                onTap: () {},
                trailing: Obx(() {
                  return IconButton(
                    onPressed: apiService.isCustLoading.value || apiService.isSettingsLoading.value ||
                                apiService.isProductLoading.value || apiService.isPPLoading.value
                        ? null // Disable the button while loading
                        : () => apiService.fetchAndStoreProductpackaging(),
                    icon: apiService.isPPLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          )
                        : const Icon(
                            Icons.cloud_download,
                            color: Colors.orange,
                          ),
                  );
                }),
              ),),
              
              Obx(() => MDownloadsMenuTile(
                noOfItems: apiService.noOfProductItems.value,
                icon: Iconsax.bag_tick,
                title: "Load Products",
                subTitle: "Click the icon and wait.",
                onTap: () {},
                trailing: Obx(() {
                  return IconButton(
                    onPressed: apiService.isCustLoading.value || apiService.isSettingsLoading.value ||
                                apiService.isProductLoading.value || apiService.isPPLoading.value
                        ? null // Disable the button while loading
                        : () => apiService.fetchAndStoreProducts(),
                    icon: apiService.isProductLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          )
                        : const Icon(
                            Icons.cloud_download,
                            color: Colors.orange,
                          ),
                  );
                }),
              ),
              ),
              Obx(() => MDownloadsMenuTile(
                noOfItems: apiService.noOfCustomerItems.value,
                icon: Iconsax.bag_tick,
                title: "Load Customers",
                subTitle: "Click the icon and wait.",
                onTap: () {},
                trailing: Obx(() {
                  return IconButton(
                    onPressed: apiService.isCustLoading.value || apiService.isSettingsLoading.value ||
                                apiService.isProductLoading.value || apiService.isPPLoading.value
                        ? null // Disable the button while loading
                        : () => apiService.fetchAndStoreCustomer(),
                    icon: apiService.isCustLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          )
                        : const Icon(
                            Icons.cloud_download,
                            color: Colors.orange,
                          ),
                  );
                }),
              ),),
              Obx(() => MDownloadsMenuTile(
                noOfItems: apiService.noOfSettingItems.value,
                icon: Iconsax.bag_tick,
                title: "Load App Settings",
                subTitle: "Click the icon and wait.",
                onTap: () {},
                trailing: Obx(() {
                  return IconButton(
                    onPressed: apiService.isCustLoading.value || apiService.isSettingsLoading.value ||
                                apiService.isProductLoading.value || apiService.isPPLoading.value
                        ? null // Disable the button while loading
                        : () => apiService.fetchAndStoreAppSettings(),
                    icon: apiService.isSettingsLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          )
                        : const Icon(
                            Icons.cloud_download,
                            color: Colors.orange,
                          ),
                  );
                }),
              ),),
           
            ],
          ),
        ),
      ),
    );
  }
}
