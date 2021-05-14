import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_sales_month_bloc/total_sales_month_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class TotalSalesMonth extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Total Sales'),
      trailing: BlocBuilder<TotalSalesMonthBloc, TotalSalesMonthState>(
        builder: (context, state) {
          if (state is TotalSalesInitial || state is Loading) return CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction);
          if (state is FetchTotalSalesFailed) return _error(context: context);

          return Text4(text: Currency.create(cents: (state as TotalSalesLoaded).totalSales), context: context);
        }
      ),
    ); 
  }

  Widget _error({required BuildContext context}) {
    return Icon(
      Icons.warning,
      color: Theme.of(context).colorScheme.danger,
    );
  }
}