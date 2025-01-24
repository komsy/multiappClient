import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:multiapp/features/authentication/controllers/login/login_controller.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/constants/sizes.dart';
import 'package:multiapp/utils/constants/text_strings.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

class MTermsAndConditionsCheckbox extends StatelessWidget {
  const MTermsAndConditionsCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Row(children: [
      SizedBox(
          width: 24,
          height: 24,
          child: Obx( ()=> Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value),
          )
        ),
      const SizedBox(height: MSizes.spaceBtwItems),
      Text.rich(
        TextSpan(children: [
          TextSpan(
              text: '${MTexts.iAgreeTo} ',
              style: Theme.of(context).textTheme.bodySmall),
          TextSpan(
              text: '${MTexts.privacyPolicy} ',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? MColors.white : MColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? MColors.white : MColors.primary,
                  )),
          TextSpan(
              text: '${MTexts.and} ',
              style: Theme.of(context).textTheme.bodySmall),
          TextSpan(
              text: MTexts.termsOfUse,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? MColors.white : MColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? MColors.white : MColors.primary,
                  )),
        ]),
      ),
    ]);
  }
}
