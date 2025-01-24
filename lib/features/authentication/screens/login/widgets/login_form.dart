import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/features/authentication/controllers/login/login_controller.dart';
import 'package:multiapp/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/validators/validation.dart';

class MLoginForm extends StatelessWidget {
  const MLoginForm({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:MSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => MValidator.validateEmail(value),
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: MTexts.email),
              ),
            const SizedBox(height: MSizes.spaceBtwInputFields),
            //Password
            Obx(() => TextFormField(
                  controller: controller.password,
                  validator: (value) => MValidator.validateEmptyText('Password',value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: MTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)),
                  ),
                )
              ),
            const SizedBox(height: MSizes.spaceBtwInputFields / 2),
            
                //Remember me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Row(children: [
                  Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.value =
                          !controller.rememberMe.value)
                  ),
                  const Text(MTexts.rememberMe),
                ]),
                TextButton(onPressed: () => Get.to(() => const ForgetPassword()), child: const Text(MTexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: MSizes.spaceBtwSections),
            //Sigin Button
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignin(), child: const Text(MTexts.signIn))),
            const SizedBox(height: MSizes.spaceBtwItems),
    
            //Create Acc Button
            // SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: const Text(MTexts.createAccount))),
          ],
        ),
      ),
    );
  }
}