import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class TextSizer {
  final BuildContext _context;

  TextSizer({required BuildContext context})
    : _context = context;

  double set({required double size, required double maxWidth}) {
    final double multiplier = ResponsiveWrapper.of(_context).isSmallerThan(TABLET)
      ? 1 
      : 0.8;
    
    return width(size: size, maxWidth: maxWidth) * multiplier;
  }

  double width({required double size, required double maxWidth}) {
    final double screenWidth = MediaQuery.of(_context).size.width;
    return ((screenWidth > maxWidth ? maxWidth : screenWidth) / 100) * size;
  }
}