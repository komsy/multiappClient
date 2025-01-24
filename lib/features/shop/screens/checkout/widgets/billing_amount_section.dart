import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiapp/features/shop/controllers/products/cart_controller.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/helpers/pricing_calculator.dart';

import '../../../../../utils/constants/sizes.dart';

class MBillingAmountSection extends StatelessWidget {
  const MBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final subTotal = controller.totalCartPrice.value;
    final taxTotal = controller.totalCartTax.value;
    
    return Column(
      children: [
        //Total Ex-Vat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Ex-Vat', style: Theme.of(context).textTheme.bodyMedium),
            Text('${MTexts.currency} ${NumberFormat('#,##0.00').format(double.parse(subTotal.toStringAsFixed(2)) -double.parse(taxTotal.toStringAsFixed(2)))}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        // const SizedBox(height: MSizes.spaceBtwItems / 2),
        // //Total Discount
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('Total Discount', style: Theme.of(context).textTheme.bodyMedium),
        //     Text('${MTexts.currency} 0.00', style: Theme.of(context).textTheme.bodyMedium),
        //   ],
        // ),
        const SizedBox(height: MSizes.spaceBtwItems / 2),
        //Total Vat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Vat', style: Theme.of(context).textTheme.bodyMedium),
            Text('${MTexts.currency} ${NumberFormat('#,##0.00').format(double.parse(taxTotal.toStringAsFixed(2)))}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: MSizes.spaceBtwItems / 2),
        //Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text('${MTexts.currency} ${NumberFormat('#,##0.00').format(subTotal)}', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}