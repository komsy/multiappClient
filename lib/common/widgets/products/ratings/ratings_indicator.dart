import 'package:flutter/material.dart';


class MRatingBarIndicator extends StatelessWidget {
  const MRatingBarIndicator({
    super.key, required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
    // RatingBarIndicator(
    //   rating: rating,
    //   itemSize: 20,
    //   unratedColor: MColors.grey,
    //   itemBuilder: (_,__)=> const Icon(Iconsax.star1, color: MColors.primary)
    // );
  }
}
