import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/date_range_cubit.dart';

class UnassignedTransactionsHeader extends StatelessWidget {

  const UnassignedTransactionsHeader({Key? key})
    : super(key: key);

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
        Text3(text: "Unmatched Bills", context: context),
        IconButton(
          key: const Key("showInfoButtonKey"),
          icon: const Icon(Icons.info),
          onPressed: () => _showInfoDialog(context: context),
          color: Theme.of(context).colorScheme.info,
        )
      ],
    );
  }

  Widget _dateRangeHeader({required BuildContext context, required DateTimeRange dateRange}) {
    return Row(
      key: const Key("dateRangeHeader"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text5(
          text: "${DateFormatter.toStringDate(date: dateRange.start)} - ${DateFormatter.toStringDate(date: dateRange.end)}",
          context: context
        ),
        IconButton(
          key: const Key("clearDatesButtonKey"),
          icon: Icon(
            Icons.clear, 
            color: Theme.of(context).colorScheme.danger,
            size: SizeConfig.getWidth(3),
          ),
          onPressed: () => context.read<DateRangeCubit>().dateRangeChanged(dateRange: null)
        )
      ],
    );
  }

  void _showInfoDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key("infoDialogKey"),
        title: const Text("What are Unmatched Bills?"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Text("These are open or unpaid transactions not currently assigned to a Nova customer."),
              const Text("The Nova Smart Pay Algorithm may still assign it to a Nova customer."),
              Text("Or, as a business you can manually assign the bill to a customer in ${BlocProvider.of<BusinessBloc>(context).business.posAccount.typeToString}."),
              const Text("Conversely, a Nova customer can also claim an unpaid bill."),
            ]
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              key: const Key("dismissInfoDialogKey"),
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