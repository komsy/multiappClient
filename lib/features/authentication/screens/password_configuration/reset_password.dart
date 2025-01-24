import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiapp/features/authentication/screens/login/login.dart';
import 'package:multiapp/utils/constants/image_strings.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(CupertinoIcons.clear))
          ],
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               //Image
              Image(image: const  AssetImage(MImages.deliveredEmailIllustration), width: THelperFunctions.screenWidth()* 0.6,),
              const SizedBox(height: MSizes.spaceBtwSections),

              //Title & SUbtitle
              Text(MTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwItems),
              Text(MTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: MSizes.spaceBtwSections),
        
              //Buttons
               SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => Get.offAll( () => const LoginScreen()),child: const Text(MTexts.done))),
              //  SizedBox(width: double.infinity,child: TextButton(onPressed: () {},child: const Text(MTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}