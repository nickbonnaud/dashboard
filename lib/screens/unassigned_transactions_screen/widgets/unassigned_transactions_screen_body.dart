import 'package:dashboard/providers/unassigned_transaction_provider.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../cubit/date_range_cubit.dart';
import 'widgets/unassigned_transactions_header.dart';
import 'widgets/unassigned_transactions_list/bloc/unassigned_transactions_list_bloc.dart';
import 'widgets/unassigned_transactions_list/unassigned_transactions_list.dart';

class UnassignedTransactionsScreenBody extends StatelessWidget {
  final UnassignedTransactionRepository _unassignedTransactionRepository = UnassignedTransactionRepository(unassignedTransactionProvider: UnassignedTransactionProvider());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(context: context),
        _changeDateButton(context: context)
      ],
    );
  }

  Widget _body({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        left: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? SizeConfig.getWidth(10)
          : SizeConfig.getWidth(1),
        right: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? SizeConfig.getWidth(10)
          : SizeConfig.getWidth(1)
      ),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(5)),
          UnassignedTransactionsHeader(),
          SizedBox(height: SizeConfig.getHeight(2)),
          Expanded(
            child: BlocProvider<UnassignedTransactionsListBloc>(
              create: (context) => UnassignedTransactionsListBloc(
                dateRangeCubit: BlocProvider.of<DateRangeCubit>(context),
                unassignedTransactionRepository: _unassignedTransactionRepository
              )..add(Init()),
              child: UnassignedTransactionsList(),
            )
          )
        ],
      ),
    );
  }

  Widget _changeDateButton({required BuildContext context}) {
    return Positioned(
      bottom: SizeConfig.getHeight(5),
      right: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.callToAction,
        child: Icon(Icons.date_range),
        onPressed: () => _showDateRangePicker(context: context),
      )
    );
  }

  void _showDateRangePicker({required BuildContext context}) async {
    final bool dateRangeSet = context.read<DateRangeCubit>().state != null;

    showDateRangePicker(
      context: context, 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),
      initialDateRange: dateRangeSet ? context.read<DateRangeCubit>().state : null,
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