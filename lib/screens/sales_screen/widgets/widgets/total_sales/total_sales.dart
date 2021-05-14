import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/total_sales_bloc.dart';

class TotalSales extends StatelessWidget {

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
                  size: 36,
                  color: Colors.white,
                ),
                Text(
                  'Total Sales',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                )
              ],
            ),
            BlocBuilder<TotalSalesBloc, TotalSalesState>(
              builder: (context, state) {
                if (state is Loading || state is TotalSalesInitial) return CircularProgressIndicator();
                if (state is FetchFailed) return _error(state: state);
                
                return Text4(
                  text: Currency.create(cents: (state as TotalSalesLoaded).totalSales), 
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

  Widget _error({required FetchFailed state}) {
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