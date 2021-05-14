import 'package:flutter/material.dart';

class SlideRight extends PageRouteBuilder {
  static final Offset _begin = Offset(-1, 0);
  static final Offset _end = Offset.zero;

  SlideRight({required Widget screen, required String name, Duration? transitionDuration})
    : super(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation
        ) => screen,
        transitionsBuilder: (
          context, 
          animation, 
          secondaryAnimation, 
          child
        ) => SlideTransition(
          position: Tween<Offset>(
            begin: _begin,
            end: _end
          ).animate(animation),
          child: child,
        ),
        transitionDuration: transitionDuration ?? Duration(milliseconds: 800),
        settings: RouteSettings(name: name)
      );
}