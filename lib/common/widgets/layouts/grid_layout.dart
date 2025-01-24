import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';


class MGridLayout extends StatelessWidget {
  const MGridLayout({
    super.key, required this.itemCount, this.mainAxisExtent = 190, required this.itemBuilder,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: mainAxisExtent,
        mainAxisSpacing: MSizes.gridViewSpacing/2,
        crossAxisSpacing: MSizes.gridViewSpacing/2,
        ),
        itemBuilder: itemBuilder,
      );
  }
}
