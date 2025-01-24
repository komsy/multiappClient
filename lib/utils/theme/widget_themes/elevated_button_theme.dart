import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class MElevatedButtonTheme {
  MElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lighMElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MColors.light,
      backgroundColor: MColors.primary,
      disabledForegroundColor: MColors.darkGrey,
      disabledBackgroundColor: MColors.buttonDisabled,
      side: const BorderSide(color: MColors.primary),
      padding: const EdgeInsets.symmetric(vertical: MSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: MColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MColors.light,
      backgroundColor: MColors.primary,
      disabledForegroundColor: MColors.darkGrey,
      disabledBackgroundColor: MColors.darkerGrey,
      side: const BorderSide(color: MColors.primary),
      padding: const EdgeInsets.symmetric(vertical: MSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: MColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MSizes.buttonRadius)),
    ),
  );
}
