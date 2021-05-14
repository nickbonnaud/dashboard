import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class SearchDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _header(),
          _date()
        ],
      ),
    );
  }

  Widget _header() {
    return BlocBuilder<RefundsListBloc, RefundsListState>(
      builder: (context, state) {
        String headerText;
        switch (state.currentFilter) {
          case FilterType.refundId:
            headerText = "Refund ID";
            break;
          case FilterType.transactionId:
            headerText = "Transaction ID";
            break;
          case FilterType.customerId:
            headerText = "Customer ID";
            break;
          case FilterType.customerName:
            headerText = "Customer Name";
            break;
          default:
            headerText = "Recent";
        }
        return Text4(text: headerText, context: context);
      }
    );
  }

  Widget _date() {
    return BlocBuilder<RefundsListBloc, RefundsListState>(
      builder: (context, state) {
        if (state.currentDateRange == null || state.currentFilter == FilterType.transactionId) return Container();

        return Row(
          key: Key("dateDisplayKey"),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text5(
              text: "${DateFormatter.toStringDate(date: state.currentDateRange!.start)} - ${DateFormatter.toStringDate(date: state.currentDateRange!.end)}",
              context: context
            ),
            IconButton(
              icon: Icon(
                Icons.clear, 
                color: Theme.of(context).colorScheme.danger,
                size: SizeConfig.getWidth(2),
              ), 
              onPressed: () => context.read<DateRangeCubit>().dateRangeChanged(dateRange: null)
            )
          ],
        );
      },
    );
  }
}