import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multiapp/common/widgets/appbar/appbar.dart';
import 'package:multiapp/features/personalization/controllers/update_name_controller.dart';
import 'package:multiapp/features/personalization/controllers/user_controller.dart';
import 'package:multiapp/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
 
    return Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
        title: Text(MTexts.changeNameTitle,style: Theme.of(context).textTheme.headlineSmall!.apply(color: MColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headings
          Text(MTexts.changeNameSubTitle,style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: MSizes.spaceBtwSections),

          Form(
            key: controller.updateUserNameFormKey,
            child: Column(
              children: [
                TextFormField(
                    controller: controller.userName,
                    validator: (value) =>
                        MValidator.validateEmptyText('User name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.username,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: MSizes.spaceBtwInputFields),
                  
                  TextFormField(
                    controller: controller.email,
                    validator: (value) => MValidator.validateEmail(value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: MTexts.email, prefixIcon: Icon(Iconsax.direct)),
                  ),
                  const SizedBox(height: MSizes.spaceBtwInputFields),

                  //Password
                  Obx(() => TextFormField(
                        controller: controller.password,
                        validator: (value) => MValidator.validatePassword(value),
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
                    ],
            ),
          ),
          const SizedBox(height: MSizes.spaceBtwSections),
          //Sigup Button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: ()=> controller.updateUserName(),
                  child: const Text(MTexts.changeName))),
          ],
        ),
      ),
    );
  }
}