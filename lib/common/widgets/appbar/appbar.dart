import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easyapp/utils/constants/colors.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/device/device_utility.dart';
// import 'package:easyapp/utils/helpers/helper_functions.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MAppBar({super.key, this.title,this.centerTitle = false,  this.showBackArrow = false, this.leadingIcon, this.leadingOnPressed, this.actions});

  final Widget? title;
  final bool showBackArrow;
  final bool centerTitle;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  
  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackArrow 
      ? IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left, color:  MColors.white )) 
      : leadingIcon != null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)) : null,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: MColors.primary,
      iconTheme: const IconThemeData(color: MColors.white, size: MSizes.iconMd),
      titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: MColors.white),
    );
    // );
  }
  
  @override
  //return appbar Height
  Size get preferredSize => Size.fromHeight(MDeviceUtils.getAppBarHeight());
}
   