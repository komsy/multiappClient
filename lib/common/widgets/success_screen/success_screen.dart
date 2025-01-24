import 'package:flutter/material.dart';
import 'package:multiapp/common/styles/spacing_styles.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String  image,title,subtitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              //Image
              // Lottie.asset(image, width: THelperFunctions.screenWidth() * 0.6),
              Image(image:  AssetImage(image), width: THelperFunctions.screenWidth()* 0.6,),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Title & SUbtitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwItems),
              Text(subtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwItems),

              //Buttons
              // SizedBox(width: double.infinity, child: ElevatedButton(onPressed: ()=> Get.to(()=> const LoginScreen()), child: const Text(MTexts.mContinue))),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed, child: const Text(MTexts.mContinue))),

            ],),
        ),
      ),
    );
  }
}