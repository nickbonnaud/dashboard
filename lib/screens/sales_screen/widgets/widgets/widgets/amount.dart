import 'package:dashboard/resources/helpers/currency.dart';
import 'package:flutter/material.dart';

class Amount extends StatelessWidget {
  final int _total;

  const Amount({required int total, Key? key})
    : _total = total,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FittedBox(
        child: Text(
          Currency.create(cents: _total),
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white
          ),
        ),
      )
    );
  }
}