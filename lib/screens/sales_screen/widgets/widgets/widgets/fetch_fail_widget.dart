import 'package:flutter/material.dart';

class FetchFailWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Flexible(
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