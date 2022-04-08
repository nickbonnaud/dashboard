import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum ErrorAnimationProp { offset }

class Shaker extends StatelessWidget {
  final Widget _child;
  final int _numberOfShakes;
  final MultiTween<ErrorAnimationProp> _tween;
  final CustomAnimationControl _control;
  final VoidCallback _onAnimationComplete;

  Shaker({
    required CustomAnimationControl control,
    required Widget child, 
    required VoidCallback onAnimationComplete,
    int numberOfShakes = 4,
    Key? key
    })
    : _control = control,
      _child = child,
      _numberOfShakes = numberOfShakes,
      _onAnimationComplete = onAnimationComplete,
      _tween = MultiTween<ErrorAnimationProp>(), super(key: key) {
        List.generate(
          _numberOfShakes, 
          (_) => _tween
            ..add(ErrorAnimationProp.offset, Tween<double>(begin: 0, end: 10), const Duration(milliseconds: 100))
            ..add(ErrorAnimationProp.offset, Tween<double>(begin: 10, end: -10), const Duration(milliseconds: 100))
            ..add(ErrorAnimationProp.offset, Tween<double>(begin: -10, end: 0), const Duration(milliseconds: 100))
        );
      }

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<MultiTweenValues<ErrorAnimationProp>>(
      control: _control,
      curve: Curves.easeOut,
      duration: _tween.duration,
      tween: _tween,
      animationStatusListener: (status) {
        if (status == AnimationStatus.completed) {
          _onAnimationComplete();
        }
      },
      builder: (BuildContext context, Widget? child, tweenValues) {
        return Transform.translate(
          offset: Offset(tweenValues.get(ErrorAnimationProp.offset), 0),
          child: child,
        );
      },
      child: _child
    );
  }
}