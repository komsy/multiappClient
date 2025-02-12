import 'package:easyapp/common/widgets/custom_shapes/containers/primary_header_containers.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/common/widgets/containers/search_container.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/features/shop/screens/customer/widgets/customer_tile.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/helpers/cloud_helper_functions.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerController.instance;

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
                      const SizedBox(height: MSizes.spaceBtwSections * 1.5),
                    ],
                  )
              ),

              // Customer List
              Transform.translate(
                offset: const Offset(0, -35), // Shift content 10 pixels upward
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
