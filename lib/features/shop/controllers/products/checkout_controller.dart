import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/features/shop/models/payment_method_model.dart';
import 'package:multiapp/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit(){
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Cash', image: MImages.cash);
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container (
          padding: const EdgeInsets.all(MSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: MSizes.spaceBtwSections),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.cash, name: 'Cash')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.mpesa, name: 'Mobile Pay')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              MPaymentTile(paymentMethod: PaymentMethodModel(image: MImages.credit, name: 'Credit Note')),
              const SizedBox(height: MSizes.spaceBtwItems / 2),
              const SizedBox(height: MSizes.spaceBtwSections),
            ],
          ),
          
        )
      )
    );
  }
}