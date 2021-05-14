import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/total_sales_today_bloc/total_sales_today_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalSalesToday extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(22),
        color: Colors.lightBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.receipt,
                  size: FontSizeAdapter.setSize(size: 4, context: context),
                  color: Colors.white,
                ),
                Text5(text: 'Total Sales', context: context, color: Colors.white)
              ],
            ),
            BlocBuilder<TotalSalesTodayBloc, TotalSalesTodayState>(
              builder: (context, state) {
                if (state is Loading || state is TotalSalesInitial) return CircularProgressIndicator();
                if (state is FetchFailed) return _error();
                
                return _amount(totalSales: (state as TotalSalesLoaded).totalSales);
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _amount({required int totalSales}) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: FittedBox(
          child: Text(
            Currency.create(cents: totalSales),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
  
  Widget _error() {
    return Flexible(
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