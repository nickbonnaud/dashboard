import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/total_tips_bloc.dart';

class TotalTips extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("totalTipsCardKey"),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(22),
        color: Colors.teal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.volunteer_activism,
                  size: FontSizeAdapter.setSize(size: 4, context: context),
                  color: Colors.white,
                ),
                Text5(text: 'Total Tips', context: context, color: Colors.white)
              ],
            ),
            BlocBuilder<TotalTipsBloc, TotalTipsState>(
              builder: (context, state) {
                if (state is Loading || state is TotalTipsInitial) return CircularProgressIndicator();
                if (state is FetchTotalTipsFailed) return _error();
                
                return _amount(total: (state as TotalTipsLoaded).totalTips);
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _error() {
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

  Widget _amount({required int total}) {
    return Flexible(
      child: FittedBox(
        child: Text(
          Currency.create(cents: total),
          style: TextStyle(
            fontSize: 25,
            color: Colors.white
          ),
        ),
      )
    );
  }
}