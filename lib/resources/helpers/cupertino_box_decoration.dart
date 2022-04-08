import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoBoxDecoration {

  static final Border _kDefaultRoundedBorder = Border.all(
    color: const CupertinoDynamicColor.withBrightness(
      color: Color(0x33000000),
      darkColor: Color(0x33FFFFFF),
    ),
    style: BorderStyle.solid,
    width: 0.0,
  );
  
  static BoxDecoration validator({required bool isValid, double borderRadius = 5.0}) {
    final BoxDecoration defaultDecoration = BoxDecoration(
      color: const CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.white,
        darkColor: CupertinoColors.black,
      ),
      border: _kDefaultRoundedBorder,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );
    
    return isValid
      ? defaultDecoration
      : defaultDecoration.copyWith(
          border: Border.all(
            color: const CupertinoDynamicColor.withBrightness(
              color: Colors.red,
              darkColor: Colors.red,
            ),
            style: BorderStyle.solid,
            width: 0.0,
          )
        );
  }
}