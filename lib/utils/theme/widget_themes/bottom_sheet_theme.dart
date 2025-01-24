import 'package:flutter/material.dart';
import 'package:multiapp/utils/constants/colors.dart';

class MBottomSheetTheme {
  MBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: MColors.white,
    modalBackgroundColor: MColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darMBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: MColors.black,
    modalBackgroundColor: MColors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
