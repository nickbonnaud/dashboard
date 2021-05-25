import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/widgets/amount.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/widgets/fetch_fail_widget.dart';
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
                  size: FontSizeAdapter.setSize(size: 4, context: context),
                  color: Colors.white,
                ),
                Text5(text: 'Total Taxes', context: context, color: Colors.white)
              ],
            ),
            BlocBuilder<TotalTaxesBloc, TotalTaxesState>(
              builder: (context, state) {
                if (state is Loading || state is TotalTaxesInitial) return CircularProgressIndicator();
                if (state is FetchFailed) return FetchFailWidget();
                
                return Amount(total: (state as TotalTaxesLoaded).totalTaxes);
              }
            )
          ],
        ),
      ),
    );
  }
}