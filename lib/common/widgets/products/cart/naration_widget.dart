import 'package:flutter/material.dart';
import 'package:multiapp/common/widgets/containers/rounded_container.dart';
import 'package:multiapp/features/shop/controllers/customer_controller.dart';
import 'package:multiapp/utils/constants/colors.dart';
import 'package:multiapp/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/sizes.dart';

class MNaration extends StatelessWidget {
  const MNaration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CustomerController.instance;

    return GestureDetector(
      child: MRoundedContainer(
        showBorder: true,
        backgroundColor: dark ? MColors.dark : MColors.white,
        padding: const EdgeInsets.only(top: MSizes.sm, bottom:  MSizes.sm, right: MSizes.sm, left: MSizes.md),
        child: Row(
          children: [
            //Textfield
            Flexible( 
              child: TextFormField(
                minLines: 1,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Have something in mind? Enter here.',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (String keyWord) {
                  controller.saveNaration(keyWord); // Pass search keyword dynamically
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}