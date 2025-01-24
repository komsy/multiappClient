import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class MOutlinedButtonTheme {
  MOutlinedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lighMOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: MColors.dark,
      side: const BorderSide(color: MColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: MColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: MSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MColors.light,
      side: const BorderSide(color: MColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: MColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: MSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MSizes.buttonRadius)),
    ),
  );
}
