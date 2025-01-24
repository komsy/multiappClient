import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/shop/controllers/products/product_controller.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/device/device_utility.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../utils/constants/sizes.dart';

class MSearchContainer extends StatelessWidget {
  const MSearchContainer(
      {super.key,
      required this.text,
      this.icon = Iconsax.search_normal,
      this.showBackground = true,
      this.showBorder = true,
      this.onTap,
      this.padding = const EdgeInsets.symmetric(horizontal: MSizes.defaultSpace),
      this.onChanged});

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
  
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: MDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(MSizes.md / 3),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? MColors.dark
                    : MColors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(MSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: MColors.grey) : null,
          ),
          child: Row(
            children: [
              // Icon(icon, color: MColors.darkerGrey),
              // const SizedBox(width: MSizes.spaceBtwItems),
              Expanded(
                // Added to ensure TextField uses available space
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: text, // Optional hint text
                    border: InputBorder
                        .none, // To match the seamless container design
                    focusedBorder: InputBorder.none, // No border when active
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
