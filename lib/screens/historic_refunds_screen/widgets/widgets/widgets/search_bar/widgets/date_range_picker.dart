import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DateRangePicker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundsListBloc, RefundsListState>(
      builder: (context, state) {
        if ([FilterType.refundId, FilterType.transactionId].contains(state.currentFilter)) return Container();
        return _button(context: context, state: state);
      }
    );
  }

  Widget _button({required BuildContext context, required RefundsListState state}) {
    return IconButton(
      icon: Icon(
        Icons.date_range,
        color: Theme.of(context).colorScheme.callToAction,
        size: FontSizeAdapter.setSize(size: 4, context: context)
      ),
      onPressed: () => _datePickerPressed(context: context, state: state)
    );
  }

  void _datePickerPressed({required BuildContext context, required RefundsListState state}) async {
    final bool dateRangeSet = state.currentDateRange != null;

    showDateRangePicker(
      context: context, 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),
      initialDateRange: dateRangeSet ? state.currentDateRange : null,
      helpText: dateRangeSet ? "Change Date Range" : "Set Date Range",
      cancelText: dateRangeSet ? "Clear" : "Cancel",
      confirmText: dateRangeSet ? "Change" : "Set",
      saveText: dateRangeSet ? "Change" : "Set",
      errorFormatText: "Incorrect Date Format",
      errorInvalidText: "Invalid Date",
      errorInvalidRangeText: "Invalid Date Range",
      fieldStartLabelText: "Start Date",
      fieldEndLabelText: "End Date",
      builder: (context, child) => Theme(
        key: Key("dateRangePickerKey"),
        data: ThemeData.light(),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: !ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
                  ? SizeConfig.getWidth(75)
                  : MediaQuery.of(context).size.width,
                maxHeight: SizeConfig.getHeight(75)
              ),
              child: child,
            )
          ],
        )
      )
    ).then((dateRange) {
      if (dateRange != null) {
        context.read<DateRangeCubit>().dateRangeChanged(dateRange: dateRange);
      }
    });
  }
}