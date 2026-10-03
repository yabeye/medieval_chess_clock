import 'package:flutter/material.dart';

class ScreenUtils {
  static Size size(BuildContext context) => MediaQuery.of(context).size;
  static double width(BuildContext context) => size(context).width;
  static double height(BuildContext context) => size(context).height;

  static double percentWidth(BuildContext context, double percent) =>
      width(context) * (percent / 100);

  static double percentHeight(BuildContext context, double percent) =>
      height(context) * (percent / 100);
}

extension ScreenUtilsExtension on BuildContext {
  // Screen Dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  // Percentage-based Sizing
  double wPercent(double percent) => screenWidth * (percent / 100);
  double hPercent(double percent) => screenHeight * (percent / 100);

  // Orientation & Layout Checks
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isTablet => screenWidth > 600;
}
