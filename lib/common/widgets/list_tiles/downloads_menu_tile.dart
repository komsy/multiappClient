import 'package:flutter/material.dart';
import 'package:easyapp/utils/constants/colors.dart';

class MDownloadsMenuTile extends StatelessWidget {
  const MDownloadsMenuTile(
      {super.key,
      this.noOfSavedItems,
      required this.noOfItems,
      required this.icon,
      required this.title,
      required this.subTitle,
      this.trailing,
      this.onTap});

  final int? noOfSavedItems;
  final int noOfItems;
  final IconData icon;
  final String title,subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
  return ListTile(
    leading: 
    Stack(
      children: [
        // The main icon
        Icon(
          icon,
          size: 45,
          color: MColors.primary,
        ),
        // Positioned badge for `noOfItems`
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 28,
            height: 25,
            decoration: BoxDecoration(
              color: MColors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                  noOfItems.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: MColors.white, fontSizeFactor: 0.8),
                ),
            ),
          ),
        ),
        // Positioned badge for `noOfItems`
        noOfSavedItems != null  ? Positioned(
          right: 0,
          top: 20,
          child: Container(
            width: 28,
            height: 25,
            decoration: BoxDecoration(
              color: MColors.success,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                  noOfSavedItems.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: MColors.white, fontSizeFactor: 0.8),
                ),
            ),
          ),
        )
        : const SizedBox() 
      ],
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    subtitle: Text(
      subTitle,
      style: Theme.of(context).textTheme.labelMedium,
    ),
    trailing: trailing,
    onTap: onTap,
  );
}

}