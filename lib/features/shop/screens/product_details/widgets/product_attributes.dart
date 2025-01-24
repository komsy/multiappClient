import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/common/widgets/containers/rounded_container.dart';
import 'package:multiapp/common/widgets/texts/product_price_text.dart';
import 'package:multiapp/common/widgets/texts/product_title_text.dart';
import 'package:multiapp/common/widgets/texts/section_heading.dart';
import 'package:multiapp/data/repositories/authentication/authentication_repository.dart';
import 'package:multiapp/features/shop/controllers/products/variation_controller.dart';
import 'package:multiapp/features/shop/models/product_model.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../utils/constants/sizes.dart';

class MProductAttributes extends StatelessWidget {
  const MProductAttributes({super.key, required this.product});

  final ProductModels product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VariationController());
   final isRsp = AuthenticationRepository.instance.isRetailPrice.value;
    return Obx(() => Column( 
          children: [
            //Selected atrribute pricing & description
            //Display variation price and stock when some variation is selected.
            if (controller.selectedVariation.value.itmCode!.isNotEmpty && controller.selectedVariation.value.itmCode! ==product.itmCode)
              MRoundedContainer(
                padding: const EdgeInsets.all(MSizes.md),
                backgroundColor: dark ? MColors.darkerGrey : MColors.grey,
                child: Column(
                  children: [
                    //Title, Price & Stock Status
                    Row(
                      children: [
                        const MSectionHeading(
                            title: 'Variation', showActionButton: false),
                        const SizedBox(width: MSizes.spaceBtwItems),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const MProductTitletext(
                                    title: 'Price: ', smallSize: true),
                                const SizedBox(width: MSizes.spaceBtwItems / 2),
                                //Actual Pri)ce
                            if(controller.selectedVariation.value.bulkPackUPrice! > 0)
                            // Text('${MTexts.currency} ${product.rspIncVat}',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .titleSmall!
                            //         .apply(
                            //             decoration:
                            //                 TextDecoration.lineThrough)),
                            // const SizedBox(width: MSizes.spaceBtwItems),
                            //Sale Price
                            
                            MProductPriceText(price: controller.getVariationPrice(product))
                          ],
                        ),

                        //Stock
                        Row(
                          children: [
                            const MProductTitletext(
                                title: 'Stock:  ', smallSize: true),
                            Text(controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleSmall),
                                
                          ],
                        )
                      ],
                    ),
                  ],
                ),

                //Variation Description
                // const MProductTitletext(
                //     title: 'Packaging: ', smallSize: true),
                MProductTitletext(
                  title:"${controller.selectedVariation.value.bulkPackUnit} (${(controller.selectedVariation.value.basePackQty!).toStringAsFixed(0)})",
                  // smallSize: true,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        const SizedBox(height: MSizes.spaceBtwItems),
            Wrap(
              // spacing: 1,
              runSpacing: 1,
              children: product.quantityPrice!.map((attribute) {
                return SizedBox(
                  width:
                      95, // Fixed width for each column to ensure proper layout
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the bulk pack unit as the header
                      MSectionHeading(
                        title: attribute.bulkPackUnit?.toString() ?? 'PCS',
                        showActionButton: false,
                      ),
                      const SizedBox(height: MSizes.spaceBtwItems / 2.5),

                      // Display the associated price below the unit with selection
                      Obx(() => Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              MChoiceChip(
                                text: isRsp
                                    ? (product.rspIncVat *
                                            attribute.basePackQty!)
                                        .toString()
                                    : attribute.bulkPackUPrice?.toString() ??
                                        '0.00',
                                selected: controller.selectedVariation.value
                                        .bulkPackUPrice ==
                                    attribute.bulkPackUPrice,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.onAttributeSelected(
                                        product,
                                        attribute.bulkPackUnit ?? '',
                                        attribute.bulkPackUPrice);
                                  }
                                },
                              ),
                            ],
                          )),
                      const SizedBox(height: MSizes.spaceBtwItems),
                    ],
                  ),
                );
              }).toList(),
            )

        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: product.quantityPrice!.map((attribute) {
        //     return Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         // Display the bulk pack unit as the header
        //         MSectionHeading(
        //           title: attribute.bulkPackUnit?.toString() ?? 'PCS',
        //           showActionButton: false,
        //         ),
        //         const SizedBox(height: MSizes.spaceBtwItems / 2),

                // // Display the associated price below the unit with selection
                // Obx(() => Wrap(
                //       spacing: 8,
                //       children: [
                //         // Assuming attribute.values contains the prices
                //         // Here, we're using `bulkPackUPrice` as the selectable prices
                //         // print(attribute.bulkPackUPrice);
                //         MChoiceChip(
                //           text: isRsp ? (product.rspIncVat * attribute.basePackQty!).toString() : attribute.bulkPackUPrice?.toString() ?? '0.00',
                //           selected: controller.selectedVariation.value.bulkPackUPrice == attribute.bulkPackUPrice,               
                //           onSelected: (selected) {
                //             if (selected) {
                //               // Update the selected price in your controller
                //               controller.onAttributeSelected(
                //                   product,
                //                   attribute.bulkPackUnit ?? '',
                //                   attribute.bulkPackUPrice);
                //             }
                //           },
                //         ),
                //         const SizedBox(height: MSizes.spaceBtwItems / 2),
                //         // Add more chips if you have multiple prices to select from
                //         // You can replace the line above with a loop if needed
                //       ],
                //     )),
        //         const SizedBox(height: MSizes.spaceBtwItems),

        //         // Divider between entries (optional)
        //         // const Divider(),
        //       ],
        //     );
        //   }).toList(),
        // )

        //Attributes
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: product.quantityPrice!
        //       .map((attribute) => Column(
                    
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               MSectionHeading(
        //                   title: attribute.bulkPackUnit.toString() ?? 'test', showActionButton: false),
        //               const SizedBox(height: MSizes.spaceBtwItems / 2),
                      
        //               Obx(() => Wrap(
        //                     spacing: 8,
        //                     children: product.quantityPrice!.map((attributeValue) {
        //                       final isSelected = controller
        //                               .selectedAttributes[attribute.itmCode] ==
        //                           attributeValue;
        //                       final available = controller
        //                           .getAttributesAvailabilityInVariation(
        //                               product.quantityPrice!,
        //                               attribute.bulkPackUPrice!.toString())
        //                           .contains(attributeValue);

        //                       return MChoiceChip(
        //                           text: attributeValue.bulkPackUPrice!.toString(),
        //                           selected: isSelected,
        //                           onSelected: available
        //                               ? (selected) {
        //                                   // if (selected & available) {
        //                                   //   controller.onAttributeSelected(
        //                                   //       product,
        //                                   //       attribute.itmCode ?? '',
        //                                   //       attributeValue);
        //                                   // }
        //                                 }
        //                               : null);
        //                     }).toList()),
        //                   )
        //             ],
        //           ))
        //       .toList(),
        // ),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const MSectionHeading(title: 'Sizes',showActionButton: false),
        //     const SizedBox(height: MSizes.spaceBtwItems / 2),
        //     Wrap(
        //       spacing: 8,
        //       children: [
        //         MChoiceChip(text: 'KE 34',selected: true, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 36',selected: false, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 36',selected: false, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 34',selected: true, onSelected: (value) {}),
        //         MChoiceChip(text: 'KE 36',selected: false, onSelected: (value) {}),
        //       ],
        //     )
        //   ],
        // ),
      ],
    )
    );
  }
}
