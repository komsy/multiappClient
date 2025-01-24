import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/containers/rounded_container.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/shop/controllers/products/checkout_controller.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/sizes.dart';

class MBillingPaymentSection extends StatelessWidget {
  const MBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark= THelperFunctions.isDarkMode(context);
    final controller = CheckoutController.instance;

    return Column(
      children: [
        MSectionHeading(title: 'Payment Method',buttonTitle: 'Change', onPressed: () => controller.selectPaymentMethod(context),),
        const SizedBox(height: MSizes.spaceBtwItems),
        Obx( () =>
          Row(
            children: [
              MRoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? MColors.light : MColors.white,
                padding: const EdgeInsets.all(MSizes.sm),
                child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),
              ),
              const SizedBox(height: MSizes.spaceBtwItems),
              Text(controller.selectedPaymentMethod.value.name, style: Theme.of(context).textTheme.bodyLarge),
              
            ],
          ),
        )
      ],
    );
  }
}