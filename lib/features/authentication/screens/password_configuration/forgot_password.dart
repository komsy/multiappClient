import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';

import '../../../../utils/validators/validation.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headings
            Text(MTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: MSizes.spaceBtwItems),
            Text(MTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: MSizes.spaceBtwSections * 2),

            //Texctfield
            Form(
              key: controller.forgetPasswordFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.appKey,
                    validator: (value) => MValidator.validateAppKey(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        labelText: MTexts.appKey,
                        prefixIcon: Icon(Iconsax.key)),
                  ),
                  const SizedBox(height: MSizes.spaceBtwSections),
                  //Password
                  Obx(() => TextFormField(
                        controller: controller.password,
                        validator: (value) =>
                            MValidator.validatePassword(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          labelText: MTexts.newPassword,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye)),
                        ),
                      )),
                  const SizedBox(height: MSizes.spaceBtwSections),
                  //Password
                  Obx(() => TextFormField(
                        controller: controller.confirmPassword,
                        validator: (value) =>
                            MValidator.validateConfirmPassword(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          labelText: MTexts.confirmNewPassword,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye)),
                        ),
                      )),
                  const SizedBox(height: MSizes.spaceBtwSections),

                  //Submit Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => controller.resetPassword(),
                          child: const Text(MTexts.submit))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
