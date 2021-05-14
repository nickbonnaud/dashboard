import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FontSizeAdapter {

  static double setSize({required double size, required BuildContext context}) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : .8
      : .8;
    return SizeConfig.getWidth(size) * multiplier;
  }
}