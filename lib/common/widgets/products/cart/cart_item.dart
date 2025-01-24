import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/texts/product_title_text.dart';
import 'package:multiapp/features/shop/models/cart_item_model.dart';

class MCartItem extends StatelessWidget {
  const MCartItem({super.key, required this.cartItem});

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Image
        // MRoundedImage(
        //   image: cartItem.image ?? '',
        //   width: 60,
        //   height: 60,
        //   //padding: EdgeInsets.all(MSizes.sm),
        //   backgroundColor: THelperFunctions.isDarkMode(context) ? MColors.darkerGrey : MColors.light,
        //   imageType: ImageType.network
        // ),
        // const SizedBox(width: MSizes.spaceBtwItems),
    
        //Title, Price & Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                // MBrandTitleTextWithVerifiedIcon(title: cartItem.brandName ?? ''),
                Flexible(
                    child:
                        MProductTitletext(title: cartItem.title, maxLines: 2)),
                if (cartItem.taxAmount > 0 )
                Row(
                  children: [
                    //Extra Space
                    const SizedBox(width: 30),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: cartItem.taxAmount.toString(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ]),
                    )
                  ],
                ),
                //Default Pricing
                  Row(
                  children: [
                    //Extra Space
                    // const SizedBox(width: 70),
                    Text.rich(
                      TextSpan(children: [
                        // TextSpan(
                        //     text: 'Variation : ',
                        //     style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: '(${cartItem.defaultPricing})' ?? '',
                            style: Theme.of(context).textTheme.bodySmall),
                      ]),
                    )
                  ],
                ),
                //Attributes 
                if (cartItem.selectedVariation != null && cartItem.selectedVariation!.isNotEmpty)
                Row(
                  children: [
                    //Extra Space
                    // const SizedBox(width: 70),
                    Text.rich(
                      TextSpan(children: [
                        // TextSpan(
                        //     text: 'Variation : ',
                        //     style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: '(${cartItem.selectedVariation})' ?? '',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ]),
                    )
                  ],
                ),
              ]),
            ],
          ),
        )
      ],
    );
  }
}