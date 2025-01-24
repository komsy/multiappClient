import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/sizes.dart';

class MCreditCustomerSection extends StatelessWidget {
  const MCreditCustomerSection({super.key});

  @override
  Widget build(BuildContext context) { 
    final controller = CreditCustomerController.instance;
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading with Actions
        MSectionHeading(
          title: 'Cash Customer',
          buttonTitle: 'Change',
          onPressed: () => controller.selectNewCrCustomerPopup(context),
          buttonTitle1: 'Add',
          onPressed1: () => controller.createCreditCustomer(context),
          showSecActionButton: true,
        ),
        // Selected Customer Details
        Obx(() {
          return controller.selectedCrClient.value.customerName.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedCrClient.value.customerName,
                      style: theme.bodyLarge,
                    ),
                    const SizedBox(height: MSizes.spaceBtwItems / 2),

                    // Phone Number Row
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey, size: 16),
                        const SizedBox(width: MSizes.spaceBtwItems),
                        Text(
                          controller.selectedCrClient.value.phoneNumber,
                          style: theme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: MSizes.spaceBtwItems / 2),

                    // pin Row
                    if(controller.selectedCrClient.value.pinNo!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.key, color: Colors.grey, size: 16),
                        const SizedBox(width: MSizes.spaceBtwItems),
                        Text(
                          THelperFunctions.limitWords(controller.selectedCrClient.value.pinNo, 5), // Limit to 2 words
                          style: theme.bodyMedium,
                          softWrap: true,
                        ),
                      ],
                    ),
                    // Address Row
                    if(controller.selectedCrClient.value.address!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.key, color: Colors.grey, size: 16),
                        const SizedBox(width: MSizes.spaceBtwItems),
                        Text(
                          THelperFunctions.limitWords(controller.selectedCrClient.value.address, 5), // Limit to 2 words
                          style: theme.bodyMedium,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  'Select Address',
                  style: theme.bodyMedium,
                );
        }),
      ],
    );
  }
}
