import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class MCartItems extends StatelessWidget {
  const MCartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    
    return Obx( 
    () => ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_,__) => const SizedBox(height: MSizes.spaceBtwSections), 
        itemCount: cartController.cartItems.length,
        itemBuilder: (_, index) => Obx(
          () { 
            final item = cartController.cartItems[index];
            return Column(
              children: [
                MCartItem(cartItem: item),
                if(showAddRemoveButtons)const SizedBox(height: MSizes.spaceBtwItems),
        
                if(showAddRemoveButtons)Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Flexible(child: MProductTitletext(title: item.title, maxLines: 1)),
                    //Add Remove Qty buttons
                    Row(
                      children: [
                        //Extra Space
                        const SizedBox(width: 70),
                        //Add remove button
                        MProductQuantityWithAddRemoveButton(
                          quantity: item.quantity, 
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneToCart(item),
                        ),
                      ],
                    ),
        
                    MProductPriceText(price: (item.price * item.quantity).toStringAsFixed(1)),
        
                  ],
                ),
              ],
            );
        }),
      ),
    );
  }
}