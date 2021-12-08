import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveLayoutHelper {

  ResponsiveRowColumnType setLayout({required BuildContext context, String deviceSize = DESKTOP}) {
    return ResponsiveWrapper.of(context).isSmallerThan(deviceSize)
      ? ResponsiveRowColumnType.COLUMN
      : ResponsiveRowColumnType.ROW;
  }
}