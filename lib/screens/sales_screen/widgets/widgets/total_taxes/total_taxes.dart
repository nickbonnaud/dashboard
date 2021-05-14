import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/total_taxes_bloc.dart';


class TotalTaxes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(22),
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.account_balance,
                  size: 36,
                  color: Colors.white,
                ),
                Text(
                  'Total Taxes',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                )
              ],
            ),
            BlocBuilder<TotalTaxesBloc, TotalTaxesState>(
              builder: (context, state) {
                if (state is Loading || state is TotalTaxesInitial) return CircularProgressIndicator();
                if (state is FetchFailed) return _error(state: state);
                
                return Text4(
                  text: Currency.create(cents: (state as TotalTaxesLoaded).totalTaxes), 
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