import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/containers/search_container.dart';
import 'package:multiapp/features/shop/controllers/customer_controller.dart';
import 'package:multiapp/features/shop/screens/customer/widgets/customer_tile.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/cloud_helper_functions.dart';


class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final controller = CustomerController.instance;

   return Scaffold(
  appBar: MAppBar( title: Text('Customers', style: Theme.of(context).textTheme.headlineSmall),showBackArrow: false),
  // body: SingleChildScrollView(
  //   padding: const EdgeInsets.all(MSizes.defaultSpace),
  //   child: Obx(
  //     () => Column(
  //       children: [
  //         //SearchBar
  //         MSearchContainer(
  //                   text: "Search Customer",
  //                   onChanged: (String keyWord) async {
  //                     controller.fetchSearchCustomer(
  //                         keyWord); // Pass a dynamic callback
  //                   },
  //                 ),
  //         // const MSearchContainer(text: "Search Customer"),
  //         const SizedBox(height: MSizes.spaceBtwSections / 2),

  //         FutureBuilder(
  //           key: Key(controller.refreshData.value.toString()),
  //           future: controller.fetchCustomers(),
  //           builder: (context, snapshot) {
  //             final response =
  //                 MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
  //             if (response != null) return response;
          
  //             final customers = snapshot.data!;
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemCount: customers.length,
  //               itemBuilder: (_, index) {
  //                 return Column(
  //                   children: [
                      
  //                     MCustomerMenuTile(customer: customers[index]),
  //                     if (index < customers.length - 1) const Divider(),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   ),
  // ),
  body: SingleChildScrollView(
  padding: const EdgeInsets.all(MSizes.defaultSpace),
  child: Obx(
    () => Column(
      children: [
        // Search Bar
        MSearchContainer(
          text: "Search Customer",
          onChanged: (String keyWord) {
            controller.fetchSearchCustomer(keyWord); // Pass search keyword dynamically
          },
        ),
        const SizedBox(height: MSizes.spaceBtwSections / 2),

        // Customer List with Search
        FutureBuilder(
          key: Key(controller.refreshData.value.toString()),
          future: controller.fetchCustomers(),
          builder: (context, snapshot) {
            final response = MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
            if (response != null) return response;

            final customers = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    MCustomerMenuTile(customer: customers[index]),
                    if (index < customers.length - 1) const Divider(),
                  ],
                );
              },
            );
          },
        ),
      ],
    ),
  ),
),

);

  }
}
