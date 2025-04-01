import 'package:easyapp/features/shop/controllers/products/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/features/shop/controllers/products/cart_controller.dart';
import 'package:easyapp/features/shop/screens/cart/cart.dart';
import 'package:easyapp/utils/constants/colors.dart';

class MCartCounterIcon extends StatelessWidget {
  const MCartCounterIcon({
    super.key,required this.iconColor,
  });

  final Color? iconColor;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    
    Get.put(OrderController());
    return Stack(
      children: [
        IconButton(onPressed: () => Get.to(() => const CartScreen()), iconSize: 40, icon: Icon(Iconsax.shopping_bag, color: iconColor)),
        Positioned(
          right: 0,
          child: Container(
            width: 27,
            height:25,
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
                        .apply(color: MColors.white, fontSizeFactor: 1)),
              ),
            ),
            ),
          )
      ],
    );
  }
}

