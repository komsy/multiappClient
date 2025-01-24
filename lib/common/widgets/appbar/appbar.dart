import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/device/device_utility.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MAppBar({super.key, this.title, this.showBackArrow = false, this.leadingIcon, this.leadingOnPressed, this.actions});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(padding: const EdgeInsets.symmetric(horizontal: MSizes.md),
    child: AppBar(
      automaticallyImplyLeading: false,
      leading: showBackArrow 
      ? IconButton(onPressed: () => Get.back(), icon: Icon(Iconsax.arrow_left, color: dark ? MColors.white : MColors.dark,)) 
      : leadingIcon != null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)) : null,
      title: title,
      actions: actions,
    ),
    );
  }
  
  @override
  //return appbar Height
  Size get preferredSize => Size.fromHeight(MDeviceUtils.getAppBarHeight());
}