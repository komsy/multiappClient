import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/icons/m_circular_icon.dart';
import '../../../../../utils/constants/colors.dart';

class MProductQuantityWithAddRemoveButton extends StatelessWidget {
  const MProductQuantityWithAddRemoveButton({
    super.key, required this.quantity, this.add, this.remove,
  });

  final int quantity;
  final VoidCallback? add,remove;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MCircularIcon(
           icon: Iconsax.minus,
           width: 32,
           height: 32,
           size: MSizes.md,
           onPressed: remove,
           color: dark ? MColors.white : MColors.black,
           backgroundColor: dark ?  MColors.darkGrey : MColors.light,
         ),
        const SizedBox(width: MSizes.spaceBtwItems),
        Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: MSizes.spaceBtwItems),
    
        MCircularIcon(
           icon: Iconsax.add,
           backgroundColor: MColors.primary,
           width: 32,
           height: 32,
           size: MSizes.md,
           color: MColors.white,
           onPressed: add,
         ),
      ],
    );
  }
}
