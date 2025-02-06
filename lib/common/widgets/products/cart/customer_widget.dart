import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:easyapp/common/widgets/containers/rounded_container.dart';
import 'package:easyapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:easyapp/features/shop/controllers/customer_controller.dart';
import 'package:easyapp/features/shop/screens/checkout/widgets/Credit_customer_section.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/text_strings.dart';
import 'package:easyapp/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/sizes.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MCustomerCode extends StatelessWidget {
  const MCustomerCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final customerController = CustomerController.instance;

    return Obx(
      () => customerController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : MRoundedContainer(
              showBorder: false,
              backgroundColor: dark ? MColors.dark : MColors.white,
              padding: const EdgeInsets.all(MSizes.sm),
              child: Column(
                children: [
                  // Dropdown for Customer Selection
                  Row(
                    children: [
                      Flexible(
                          child: Obx(() => DropdownSearch<String>(
                                popupProps: const PopupProps.menu(
                                  isFilterOnline: true,
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                ),
                                items: customerController.featuredCustomers
                                    .map((customer) => customer.companyName)
                                    .toList(),
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Customer Name",
                                  ),
                                ),
                                onChanged: (String? newSelectedCustomer) {
                                  if (newSelectedCustomer != null) {
                                    customerController.selectCustomer(newSelectedCustomer);
                                  }
                                },
                                selectedItem: customerController.selectedCustomer.value.companyName.isNotEmpty
                                    ? customerController.selectedCustomer.value.companyName
                                    : null,
                              )),
                        )
                    ],
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems / 2),

                  // Credit Limit
                  _buildKeyValueRow(
                    context,
                    key: 'Credit Limit:',
                    value: (customerController.selectedCustomer.value.crLimit ??
                                0) >
                            0
                        ? '${MTexts.currency} ${NumberFormat('#,##0.00').format(customerController.selectedCustomer.value.crLimit)}'
                        : '0.00',
                  ),
                  const SizedBox(height: MSizes.spaceBtwItems / 2),

                  // Outstanding Balance
                  _buildKeyValueRow(
                    context,
                    key: 'Outstanding Bal:',
                    value: (customerController
                                    .selectedCustomer.value.currBalance ??
                                0) >
                            0
                        ? '${MTexts.currency} ${NumberFormat('#,##0.00').format(customerController.selectedCustomer.value.currBalance)}'
                        : '0.00',
                  ),
              // const SizedBox(height: MSizes.spaceBtwItems / 2),
              // const Divider(),
              // const MCreditCustomerSection(),
              // Conditional rendering for Cash Customers
                if (customerController.selectedCustomer.value.companyName.contains('Cash'))
                  const Column(
                    children: [
                      SizedBox(height: MSizes.spaceBtwItems / 2),
                      Divider(),
                      MCreditCustomerSection(),  
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // Helper to Build Key-Value Rows
  Widget _buildKeyValueRow(BuildContext context,
      {required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
