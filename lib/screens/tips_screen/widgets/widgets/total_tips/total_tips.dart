import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/total_tips_bloc.dart';

class TotalTips extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  size: 36,
                  color: Colors.white,
                ),
                Text(
                  'Total Tips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                )
              ],
            ),
            BlocBuilder<TotalTipsBloc, TotalTipsState>(
              builder: (context, state) {
                if (state is Loading || state is TotalTipsInitial) return CircularProgressIndicator();
                if (state is FetchTotalTipsFailed) return _error(state: state);
                
                return Text4(
                  text: Currency.create(cents: (state as TotalTipsLoaded).totalTips), 
                  context: context,
                  color: Colors.white,
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _error({required FetchTotalTipsFailed state}) {
    return Text(
      state.error,
      style: TextStyle(
        fontSize: 34,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
    );
  }
}