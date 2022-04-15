import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class SearchDisplay extends StatelessWidget {

  const SearchDisplay({Key? key})
    : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _header(),
          _date()
        ],
      )
    );
  }

  Widget _header() {
    return BlocBuilder<TransactionsListBloc, TransactionsListState>(
      buildWhen: (previousState, currentState) => previousState.currentFilter != currentState.currentFilter,
      builder: (context, state) {
        String headerText;
        switch (state.currentFilter) {
          case FilterType.transactionId:
            headerText = "Transaction ID";
            break;
          case FilterType.status:
            headerText = "Transaction Status";
            break;
          case FilterType.customerId:
            headerText = "Customer ID";
            break;
          case FilterType.customerName:
            headerText = "Customer Name";
            break;
          case FilterType.employeeName:
            headerText = "Employee Name";
            break;
          default:
            headerText = "Recent";
        }
        return Text4(text: headerText, context: context);
      }
    );
  }

  Widget _date() {
    return BlocBuilder<TransactionsListBloc, TransactionsListState>(
      builder: (context, state) {
        if (state.currentDateRange == null || state.currentFilter == FilterType.transactionId) return Container();

        return Row(
          key: const Key("dateDisplayKey"),
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