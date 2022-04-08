import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/total_tips_today_bloc/total_tips_today_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalTipsToday extends StatelessWidget {
  
  const TotalTipsToday({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(22),
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
                Text5(text: 'Tips', context: context, color: Colors.white)
              ],
            ),
            BlocBuilder<TotalTipsTodayBloc, TotalTipsTodayState>(
              builder: (context, state) {
                if (state is Loading || state is TotalTipsInitial) return const CircularProgressIndicator();
                if (state is FetchFailed) return _error();
                
                return _amount(totalTips: (state as TotalTipsLoaded).totalTips);
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _amount({required int totalTips}) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: FittedBox(
          child: Text(
            Currency.create(cents: totalTips),
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
  
  Widget _error() {
    return const Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: FittedBox(
          child: Text(
            "Error Loading!",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
}