import 'package:flutter/material.dart';
import 'package:easyapp/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:easyapp/utils/constants/sizes.dart';
import 'package:easyapp/utils/device/device_utility.dart';

class OnBoardingskip extends StatelessWidget {
  const OnBoardingskip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:MDeviceUtils.getAppBarHeight(),
      right:MSizes.defaultSpace,
      child: TextButton(
        onPressed: () =>OnBoardingController.instance.skipPage(),
        child: const Text("Skip"),
      ),
    );
  }
}
