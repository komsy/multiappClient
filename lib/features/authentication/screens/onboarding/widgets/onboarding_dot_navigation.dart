import 'package:flutter/material.dart';
import 'package:multiapp/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/device/device_utility.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: MDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: MSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController, 
        onDotClicked: controller.dotNavigationClick,
        count: 2,
        effect: ExpandingDotsEffect(activeDotColor: dark ? MColors.light : MColors.dark, dotHeight:6),
      )
    );
  }
}
