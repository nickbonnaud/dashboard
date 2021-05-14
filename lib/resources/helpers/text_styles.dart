import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class VeryBoldText1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(10) * multiplier
      ),
    );
  }
}

class VeryBoldText2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(9) * multiplier
      ),
    );
  }
}

class VeryBoldText3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(8) * multiplier
      ),
    );
  }
}

class VeryBoldText4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(7) * multiplier
      ),
    );
  }
}

class VeryBoldText5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const VeryBoldText5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6) * multiplier
      ),
    );
  }
}

class BoldTextCustom extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final double _size;
  final Color? _color;

  const BoldTextCustom({required String text, required BuildContext context, required double size, Color? color})
    : _text = text,
      _context = context,
      _size = size,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: _size * multiplier
      ),
    );
  }
}

class BoldText1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(8) * multiplier
      ),
    );
  }
}

class BoldText2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(7) * multiplier,
      ),
    );
  }
}

class BoldText3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6) * multiplier
      ),
    );
  }
}

class BoldText4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(5) * multiplier
      ),
    );
  }
}

class BoldText5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const BoldText5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(4) * multiplier,
        
      ),
    );
  }
}

class TextCustom extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final double _size;
  final Color? _color;
  
  TextCustom({required String text, required BuildContext context, required double size, Color? color})
    : _text = text,
      _context = context,
      _size = size,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: _size * multiplier
      ),
    );
  }
}

class Text1 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text1({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(6) * multiplier
      ),
    );
  }
}

class Text2 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text2({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(5) * multiplier,
      ),
    );
  }
}

class Text3 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text3({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(4) * multiplier
      ),
    );
  }
}

class Text4 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text4({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
      color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(3) * multiplier
      ),
    );
  }
}

class Text5 extends StatelessWidget {
  final String _text;
  final BuildContext _context;
  final Color? _color;

  const Text5({required String text, required BuildContext context, Color? color})
    : _text = text,
      _context = context,
      _color = color;

  @override
  Widget build(BuildContext context) {
    double multiplier = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
        ? 1.5 
        : 1/1.1
      : 1/1.5;
    return Text(
      _text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: _color == null ? Theme.of(_context).colorScheme.onPrimary : _color,
        fontSize: SizeConfig.getWidth(2) * multiplier
      ),
    );
  }
}