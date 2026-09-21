import 'package:flutter/material.dart';

/// Spacing, radius, and sizing constants for MyTimo
class AppSizes {
  AppSizes._();

  // Spacing / Margins / Paddings
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  // Border Radii
  static const double radiusXS = 6.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radius2XL = 28.0;
  static const double radiusFull = 999.0;

  static const BorderRadius roundedS = BorderRadius.all(Radius.circular(radiusS));
  static const BorderRadius roundedM = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius roundedL = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius roundedXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius rounded2XL = BorderRadius.all(Radius.circular(radius2XL));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(radiusFull));

  // Component Dimensions
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 38.0;
  static const double inputHeight = 50.0;
  static const double avatarSize = 44.0;
  static const double floatingScanButtonSize = 58.0;
  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 22.0;
  static const double iconSizeLarge = 28.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> floatingButtonShadow = [
    BoxShadow(
      color: Color(0x40E53935),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
