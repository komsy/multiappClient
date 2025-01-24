import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/features/shop/models/credit_customer_model.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';

class MSingleCrCustomer extends StatelessWidget {
  const MSingleCrCustomer({super.key, required this.crCustomer, required this.onTap});
  
  final CreditCustomerModel crCustomer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CreditCustomerController.instance;

    return Obx(() {
      final selectedCrCustomerId = controller.selectedCrClient.value.customerName;
      final selectedCrCustomer = selectedCrCustomerId == crCustomer.customerName;
      
      return InkWell(
        onTap: onTap,
        child: MRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(MSizes.md),
          width: double.infinity,
          backgroundColor: selectedCrCustomer ? MColors.primary.withOpacity(0.5) : Colors.transparent,
          borderColor: selectedCrCustomer ? Colors.transparent : dark ? MColors.darkerGrey : MColors.grey,
          margin: const EdgeInsets.only(bottom: MSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(selectedCrCustomer ? Iconsax.tick_circle5 : null, color: selectedCrCustomer ? dark ? MColors.light: MColors.dark : null),
                ),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    crCustomer.customerName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                const SizedBox(height: MSizes.sm / 2),
            
                // Phone Number, Pin, and Address
                Row(
                  children: [
                    Text(
                      crCustomer.phoneNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: MSizes.md),
                    Text(
                      crCustomer.pinNo.toString(),
                      softWrap: true,
                    ),
                    const SizedBox(width: MSizes.md),
                    Text(
                      THelperFunctions.limitWords(crCustomer.address, 2), // Limit to 2 words
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            ],
          ),
        ),
      );
    });
  }
} 

