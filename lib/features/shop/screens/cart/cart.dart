import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/common/widgets/loaders/animation_loader.dart';
import 'package:multiapp/features/shop/controllers/credit_customer_controller.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/screens/checkout/checkout.dart';
import 'package:multiapp/navigation_menu.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';

import '../../../../utils/constants/text_strings.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;


    return Scaffold(
      appBar: MAppBar(
          title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true),
      body: Obx(() {
        //Nothing found widgetr
        final emptyWidget = MAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY',
          animation: MImages.cartAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        } else {
          return const SingleChildScrollView(
              // child: Padding(
              padding: EdgeInsets.all(MSizes.defaultSpace),
              //Items in acart
              child: MCartItems());
        }
      }),

      //Checkout Button
      bottomNavigationBar: Obx((){  
       if (controller.cartItems.isEmpty) {
          return const SizedBox();  // No items in cart;
        } else {
          return   Padding(
                padding: const EdgeInsets.all(MSizes.defaultSpace),
                child: ElevatedButton(
                    onPressed: () => Get.to(() => const CheckoutScreen()),
                    child: Obx(() => Text(
                        'Check out ${MTexts.currency} ${controller.totalCartPrice.value}'))),
              );
          }
      }),
    );
  }
}
