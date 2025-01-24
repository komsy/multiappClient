
import 'package:flutter/material.dart';
import 'package:multiapp/utils/theme/widget_themes/appbar_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/chip_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/text_field_theme.dart';
import 'package:multiapp/utils/theme/widget_themes/text_theme.dart';

import '../constants/colors.dart';

class MAppTheme {
  MAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: MColors.grey,
    brightness: Brightness.light,
    primaryColor: MColors.primary,
    textTheme: MTextTheme.lighMTextTheme,
    chipTheme: MChipTheme.lightChipTheme,
    scaffoldBackgroundColor: MColors.white,
    appBarTheme: MAppBarTheme.lightAppBarTheme,
    checkboxTheme: MCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: MBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: MElevatedButtonTheme.lighMElevatedButtonTheme,
    outlinedButtonTheme: MOutlinedButtonTheme.lighMOutlinedButtonTheme,
    inputDecorationTheme: MTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: MColors.grey,
    brightness: Brightness.dark,
    primaryColor: MColors.primary,
    textTheme: MTextTheme.darkTextTheme,
    chipTheme: MChipTheme.darkChipTheme,
    scaffoldBackgroundColor: MColors.black,
    appBarTheme: MAppBarTheme.darMAppBarTheme,
    checkboxTheme: MCheckboxTheme.darMCheckboxTheme,
    bottomSheetTheme: MBottomSheetTheme.darMBottomSheetTheme,
    elevatedButtonTheme: MElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MTextFormFieldTheme.darkInputDecorationTheme,
  );
}
