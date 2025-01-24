import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/utils/constants/colors.dart';

class MDownloadsMenuTile extends StatelessWidget {
  const MDownloadsMenuTile(
      {super.key,
      required this.noOfItems,
      required this.icon,
      required this.title,
      required this.subTitle,
      this.trailing,
      this.onTap});

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
          size: 38,
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