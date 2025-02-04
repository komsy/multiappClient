import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/common/widgets/containers/rounded_container.dart';
import 'package:easyapp/features/shop/controllers/products/checkout_controller.dart';
import 'package:easyapp/features/shop/models/payment_method_model.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/helpers/helper_functions.dart';

class MPaymentTile extends StatelessWidget {
  const MPaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: MRoundedContainer(
        width: 60,
        height: 40,
        backgroundColor: THelperFunctions.isDarkMode(context) ? MColors.light : MColors.white,
        padding: const EdgeInsets.all(MSizes.md),
        child: Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
      ),
      title: Text(paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}