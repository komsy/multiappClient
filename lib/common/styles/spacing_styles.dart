import 'package:flutter/material.dart';
import 'package:multiapp/utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MSizes.appBarHeight,
    left: MSizes.defaultSpace,
    bottom: MSizes.defaultSpace,
    right: MSizes.defaultSpace,
  );
}