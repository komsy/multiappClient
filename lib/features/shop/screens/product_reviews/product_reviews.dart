import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/utils/constants/sizes.dart';

import '../../../../common/widgets/products/ratings/ratings_indicator.dart';
import 'widgets/rating_progress_indicator.dart';


class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: const MAppBar(title: Text('Reviews & Ratings'), showBackArrow: true ),

      //Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(' Ratings and Reviews'),
              const SizedBox(height: MSizes.spaceBtwItems),

              //Overall Product Ratings
              const MOverallProductRating(),
              const MRatingBarIndicator(rating: 3.5),
              Text('12,000', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: MSizes.spaceBtwSections),

              //User Reviews
              // const UserReviewCard(),
              // const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
