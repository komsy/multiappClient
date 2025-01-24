import 'package:flutter/material.dart';
import 'package:multiapp/utils/constants/text_strings.dart';

class MProductPriceText extends StatelessWidget {
  const MProductPriceText({
    super.key,
    this.currencySign = MTexts.currency,
    required this.price,
    this.maxLines =1,
    this.isLarge = false,
    this.linethrough = false,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool linethrough;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      // currencySign + price,
      price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
      ?  Theme.of(context).textTheme.headlineSmall!.apply(decoration: linethrough ? TextDecoration.lineThrough : null)
      :  Theme.of(context).textTheme.titleLarge!.apply(decoration: linethrough ? TextDecoration.lineThrough : null),

    );
  }
}
