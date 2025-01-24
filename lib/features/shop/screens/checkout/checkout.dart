import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/containers/rounded_container.dart';
import 'package:multiapp/common/widgets/products/cart/naration_widget.dart';
import 'package:multiapp/common/widgets/products/cart/customer_widget.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/controllers/products/order_controller.dart';
import 'package:multiapp/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/helpers/pricing_calculator.dart';
import 'package:multiapp/utils/popups/loaders.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'widgets/billing_amount_section.dart';
import 'widgets/billing_payment_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CartController.instance;
    final subTotal = controller.totalCartPrice.value;
    final orderController = Get.put(OrderController());
    // final customercontroller = Get.put(CustomerController());
    final totalAmount = MPricingCalculator.calculateTotalPrice(subTotal,'KE');

    return Scaffold(
      appBar: MAppBar(title: Text('Order Review', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            children: [
              //Items in cart
              const MCartItems(showAddRemoveButtons: false),
              const SizedBox(height: MSizes.spaceBtwSections),
              
              //Coupon Textfield
              const MNaration(),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Customer Section
              MRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(MSizes.md),
                backgroundColor: dark ? MColors.black : MColors.white,
                child: const Column(
                  children: [
                    //customer Textfield
                    MCustomerCode(),
                    SizedBox(height: MSizes.spaceBtwItems),
                  ],
                ),
              ),
              const SizedBox(height: MSizes.spaceBtwSections),
              //Billing Section
              MRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(MSizes.md),
                backgroundColor: dark ? MColors.black : MColors.white,
                child: const Column(
                  children: [
                    //Pricing
                    MBillingAmountSection(),
                    SizedBox(height: MSizes.spaceBtwItems),

                    //Divider
                    // Divider(),
                    // SizedBox(height: MSizes.spaceBtwItems),

                    // // Payment Methods
                    // MBillingPaymentSection(),
                    // SizedBox(height: MSizes.spaceBtwItems),

                    //Address
                    // MBillingAddressSection(),
                    // SizedBox(height: MSizes.spaceBtwItems),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      
      //Checkout Button
      bottomNavigationBar:    Padding(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: ElevatedButton(
              // onPressed: () => Get.to(() => SuccessScreen(
              //   image: MImages.successfulPaymentIcon,
              //   title: 'Payment Success!',
              //   subtitle: 'Your item will be shipped soon!',
              //   onPressed: () => Get.offAll(() => const NavigationMenu()),
              // )), 
              onPressed: subTotal > 0 
                 ? () => orderController.processOrder(subTotal)
                 : () => MLoaders.warningSnackBar(title: 'Empty Cart', message:'Add items in the cart in order to procees.'),
              child: Text('Check out ${MTexts.currency} $subTotal')
            ),
      ),
    );
  }
}
