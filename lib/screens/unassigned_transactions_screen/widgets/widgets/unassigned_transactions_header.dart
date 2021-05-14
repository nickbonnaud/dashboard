import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/date_range_cubit.dart';

class UnassignedTransactionsHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateRangeCubit, DateTimeRange?>(
      builder: (context, dateRange) {
        return dateRange == null
          ? _noDateRangeHeader(context: context)
          : _dateRangeHeader(context: context, dateRange: dateRange);
      }
    );
  }

  Widget _noDateRangeHeader({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text3(text: "Unassigned Transactions", context: context),
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () => _showInfoDialog(context: context),
          color: Theme.of(context).colorScheme.info,
        )
      ],
    );
  }

  Widget _dateRangeHeader({required BuildContext context, required DateTimeRange dateRange}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text4(
          text: "${DateFormatter.toStringDate(date: dateRange.start)} - ${DateFormatter.toStringDate(date: dateRange.end)}",
          context: context
        ),
        IconButton(
          icon: Icon(
            Icons.clear, 
            color: Theme.of(context).colorScheme.danger,
            size: FontSizeAdapter.setSize(size: 3, context: context),
          ),
          onPressed: () => context.read<DateRangeCubit>().dateRangeChanged(dateRange: null)
        )
      ],
    );
  }

  void _showInfoDialog({required BuildContext context}) {
    final PosAccount posAccount = BlocProvider.of<BusinessBloc>(context).business.posAccount;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("What are Unassigned Transactions?"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("These are open or unpaid transactions not currently assigned to a Nova customer."),
              Text("The Nova Smart Pay Algorithm may still assign it to a Nova customer."),
              Text("Or as a business, you can manually assign the transaction to the customer in ${posAccount.typeToString}."),
              Text("Conversely, a Nova customer can also claim an Open transaction."),
            ]
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              child: Text(
                "Close",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      )
    );
  }
}