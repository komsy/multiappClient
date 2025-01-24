import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/screens/cart/cart.dart';
import 'package:multiapp/utils/constants/colors.dart';

class MCartCounterIcon extends StatelessWidget {
  const MCartCounterIcon({
    super.key,required this.iconColor,
  });

  final Color? iconColor;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    
    return Stack(
      children: [
        IconButton(onPressed: () => Get.to(() => const CartScreen()), icon: Icon(Iconsax.shopping_bag, color: iconColor)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: MColors.black,
              borderRadius: BorderRadius.circular(100),  
            ),
            child: Center(
              child: Obx(
                () => Text(controller.noOfCartItems.value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: MColors.white, fontSizeFactor: 0.8)),
              ),
            ),
            ),
          )
      ],
    );
  }
}

