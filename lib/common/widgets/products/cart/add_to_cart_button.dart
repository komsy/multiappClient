import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/features/shop/screens/product_details/product_detail.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/enums.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({super.key, required this.product});

  final ProductModels product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
  final isQuantityPrice = AuthenticationRepository.instance.isQuantityPrice;

    return InkWell(
      onTap: () {
        //If the product have variations then show the product details for variation selection
        //Else add product to the cart.
        if (!isQuantityPrice.value && product.quantityPrice != null && product.quantityPrice!.length > 1) {
          Get.to(() => ProductDetailScreen(product: product));
        } else {
          final cartitem = cartController.convertToCartItem(product, 1);
          cartController.addOneToCart(cartitem);
        }
      },
      child: Obx(() {
        final productQuantityInCart = cartController.getProductQuantityInCart(product.itmCode);
        return Container(
          decoration: BoxDecoration(
              color: productQuantityInCart > 0 ? MColors.primary:  MColors.dark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MSizes.cardRadiusMd),
                bottomRight: Radius.circular(MSizes.productImageRadius),
              )),
          child:  SizedBox(
            width: MSizes.iconLg,
            height: MSizes.iconLg,
            child: Center(
              child: productQuantityInCart > 0 
              ? Text(productQuantityInCart.toString(), style: Theme.of(context).textTheme.bodyLarge!.apply(color: MColors.white))
              : const Icon(Iconsax.add, color: MColors.white),
            ),
          ),
        );
      }),
    );
  }
}
