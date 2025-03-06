import 'package:easyapp/common/widgets/containers/rounded_container.dart';
import 'package:easyapp/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/device/device_utility.dart';
import 'package:easyapp/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/containers/search_container.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/helpers/cloud_helper_functions.dart';
import 'package:intl/intl.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              MPrimaryHeaderContainer(
                  child: Column(
                    children: [
                      MAppBar(title: Text('Customers',style: Theme.of(context).textTheme.headlineMedium!.apply(color: MColors.white)),),

                      // Search Bar
                      MSearchContainer(
                        text: "Search Customer",
                        onChanged: (String keyWord) {
                          controller.fetchSearchCustomer(
                              keyWord); // Pass search keyword dynamically
                        },
                      ),
                      const SizedBox(height: MSizes.spaceBtwSections * 1.2),
                    ],
                  )
              ),

              // Customer List
              Transform.translate(
                offset: const Offset(0, -35,), // Shift content 10 pixels upward
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MSizes.defaultSpace),
                  child: FutureBuilder(
                    key: Key(controller.refreshData.value.toString()),
                    future: controller.fetchCustomers(),
                    builder: (context, snapshot) {
                      final response =MCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                      if (response != null) return response;
                      

                      final customers = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: customers.length,
                        itemBuilder: (_, index) {
                        final customer = customers[index];
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: MRoundedContainer(
                              showBorder: false,
                              padding: const EdgeInsets.all(MSizes.sm),
                              backgroundColor: dark ? MColors.dark : MColors.light,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Text(customer.companyName,overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.bodyMedium!
                                                    .apply(color: MColors.primary, fontWeightDelta: 2),
                                              ),
                                              const SizedBox(height: MSizes.spaceBtwItems / 2),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text('Limit: ${NumberFormat('#,##0').format(double.parse(customer.crLimit!.toStringAsFixed(2)))} ',overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleMedium,
                                                    ),
                                                  ),
                                                  Expanded(child: Text('Bal: ${NumberFormat('#,##0').format(double.parse(customer.currBalance.toStringAsFixed(2)))} ', style: Theme.of(context).textTheme.titleMedium!
                                                    .apply(color: MColors.error, fontWeightDelta: 1))),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                  
                                    ],
                                  ),
                                  if (index < customers.length - 1) const Divider(),
                                ],
                              ),
                            ),
                            
                          );
                          // return Column(
                          //   children: [
                          //     MCustomerMenuTile(customer: customers[index]),
                          //     if (index < customers.length - 1) const Divider(),
                          //   ],
                          // );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
