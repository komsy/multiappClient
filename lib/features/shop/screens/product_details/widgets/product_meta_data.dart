import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/texts/product_title_text.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class MProductMetaData extends StatelessWidget {
  const MProductMetaData({super.key, required this.product});

  final ProductModels product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    // final salePercentage = controller.calaculateSalePercentage(product.price, product.salePrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Price & Sale Price
        Row(
          children: [
            // MRoundedContainer(
            //   radius: MSizes.sm,
            //   backgroundColor: MColors.secondary.withOpacity(0.8),
            //   padding: const EdgeInsets.symmetric(horizontal: MSizes.sm, vertical: MSizes.xs),
            //   child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color: MColors.black)),
            // ),
            // const SizedBox(width: MSizes.spaceBtwItems),




            // if(product.quantityPrice != null && product.quantityPrice!.length > 1 && product.wspIncVat > 0)
            //   Text('${MTexts.currency} ${product.wspIncVat}', style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
            // if(product.quantityPrice != null && product.quantityPrice!.length > 1 && product.wspIncVat > 0)
            //   const SizedBox(width: MSizes.spaceBtwItems),
            // // MProductPriceText(price: controller.getProductPrice(product), isLarge: true),
            // // const SizedBox(width: MSizes.spaceBtwItems / 1.5), 
            // //Checking if single product and display the price
            // if(product.quantityPrice != null && product.quantityPrice!.length > 1 && product.rspIncVat > 0)
            //   Text('${MTexts.currency} ${product.rspIncVat}', style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
            // if(product.quantityPrice != null && product.quantityPrice!.length > 1 && product.rspIncVat > 0)
            //   const SizedBox(width: MSizes.spaceBtwItems),
            MProductPriceText(price: controller.getProductPrice(product), isLarge: true),
            const SizedBox(width: MSizes.spaceBtwItems / 1.5),                      
          // ],                     
          ],
        ),
        //Title
        MProductTitletext(title: product.longName),
        const SizedBox(width: MSizes.spaceBtwItems / 1.5),

        //Stock Status
        Row(
          children: [
             const MProductTitletext(title: 'Stock: '),
             const SizedBox(width: MSizes.spaceBtwItems),
            Text(controller.getProductStockStatus(product.currBalance), style: Theme.of(context).textTheme.titleMedium),
             const SizedBox(width: MSizes.spaceBtwItems),
            Text("(${product.currBalance.toString()})", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: MSizes.spaceBtwItems),
      ],
    );
  }
}