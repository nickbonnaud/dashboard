import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.callToAction,
          )
        ),
      ),
    );
  }
}