import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/utils/constants/colors.dart';


class MRatingBarIndicator extends StatelessWidget {
  const MRatingBarIndicator({
    super.key, required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemSize: 20,
      unratedColor: MColors.grey,
      itemBuilder: (_,__)=> const Icon(Iconsax.star1, color: MColors.primary)
    );
  }
}
