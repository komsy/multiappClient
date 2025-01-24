import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/layouts/grid_layout.dart';
import 'package:multiapp/common/widgets/shimmers/shimmer.dart';
import 'package:multiapp/utils/constants/sizes.dart';
 
class MVerticalProductShimmer extends StatelessWidget {
  const MVerticalProductShimmer({
    super.key,
    this.itemCount = 9,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return MGridLayout(
      itemCount: itemCount, 
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image
            MShimmerEffect(width: 180, height: 100),
            SizedBox(height: MSizes.spaceBtwItems),

            //Text
            MShimmerEffect(width: 160, height: 15),
            SizedBox(height: MSizes.spaceBtwItems / 2),
            MShimmerEffect(width: 110, height: 15),
          ],
        ),
      )
    );
  }
}
