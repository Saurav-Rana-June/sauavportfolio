import 'package:flutter/material.dart';

class Spacing {
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
}

extension SpacingBox on double {
  Widget get gapH => SizedBox(height: this);
  Widget get gapW => SizedBox(width: this);
}
