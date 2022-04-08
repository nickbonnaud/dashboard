import 'package:flutter/material.dart';

class FetchFailWidget extends StatelessWidget {

  const FetchFailWidget({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: FittedBox(
        child: Text(
          "Error Loading!",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      )
    );
  }
}