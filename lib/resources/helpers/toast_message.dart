import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  final BuildContext _context;
  final String _message;
  final Color _color;
  final int _durationSeconds;
  final ToastGravity _gravity;
  final double? _fontSize;

  ToastMessage({
    required BuildContext context,
    required String message,
    required Color color,
    int durationSeconds = 3,
    ToastGravity gravity = ToastGravity.CENTER,
    double? fontSize
  })
    :  _context = context,
      _message = message,
      _color = color,
      _durationSeconds = durationSeconds,
      _gravity = gravity,
      _fontSize = fontSize;

  Future<void> showToast() {
    final FToast fToast = FToast();
    fToast.init(_context);
    final Duration duration = Duration(seconds: _durationSeconds);
    fToast.showToast(
      child: _toast(),
      toastDuration: duration,
      gravity: _gravity,
    );
    return Future.delayed(duration);
  }
  
  Widget _toast() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: _color
        ),
        child: TextCustom(
          text: _message, 
          context:_context, 
          size: _fontSize == null
            ? SizeConfig.getWidth(5)
            : _fontSize!,
          color: Colors.white,
        ),
      );
  }
}