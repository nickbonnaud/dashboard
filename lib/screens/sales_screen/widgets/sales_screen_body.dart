import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/net_sales/bloc/net_sales_bloc.dart';
import 'widgets/net_sales/net_sales.dart';
import 'widgets/sales_header.dart';
import 'widgets/total_sales/bloc/total_sales_bloc.dart';
import 'widgets/total_sales/total_sales.dart';
import 'widgets/total_taxes/bloc/total_taxes_bloc.dart';
import 'widgets/total_taxes/total_taxes.dart';
import 'widgets/total_tips/bloc/total_tips_bloc.dart';
import 'widgets/total_tips/total_tips.dart';

class SalesScreenBody extends StatelessWidget {
  final TransactionRepository _transactionRepository;

  const SalesScreenBody({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetSalesBloc>(
          create: (context) => NetSalesBloc(
            dateRangeCubit: context.read<DateRangeCubit>(),
            transactionRepository: _transactionRepository
          )..add(InitNetSales())
        ),

        BlocProvider<TotalSalesBloc>(
          create: (context) => TotalSalesBloc(
            dateRangeCubit: context.read<DateRangeCubit>(),
            transactionRepository: _transactionRepository
          )..add(InitTotalSales())
        ),

        BlocProvider<TotalTipsBloc>(
          create: (context) => TotalTipsBloc(
            dateRangeCubit: context.read<DateRangeCubit>(),
            transactionRepository: _transactionRepository
          )..add(InitTotalTips())
        ),

        BlocProvider<TotalTaxesBloc>(
          create: (context) => TotalTaxesBloc(
            dateRangeCubit: context.read<DateRangeCubit>(),
            transactionRepository: _transactionRepository
          )..add(InitTotalTaxes())
        )
      ],
      child: Stack(
        children: [
          _body(context: context),
          _changeDateButton(context: context),
        ],
      )
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
          SalesHeader(),
          SizedBox(height: SizeConfig.getHeight(2)),
          _salesData(context: context),
          SizedBox(height: SizeConfig.getHeight(3)),
          _taxTipData(context: context)
        ],
      ),
    );
  }
  
  Widget _salesData({required BuildContext context}) {
    return ResponsiveRowColumn(
      rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(TABLET),
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      columnSpacing: SizeConfig.getHeight(3),
      rowSpacing: SizeConfig.getWidth(3),
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: NetSales()
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalSales()
        )
      ],
    );
  }

  Widget _taxTipData({required BuildContext context}) {
    return ResponsiveRowColumn(
      rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(TABLET),
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      columnSpacing: SizeConfig.getHeight(3),
      rowSpacing: SizeConfig.getWidth(3),
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalTips()
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalTaxes()
        )
      ],
    );
  }

  Widget _changeDateButton({required BuildContext context}) {
    return Positioned(
      bottom: SizeConfig.getHeight(5),
      right: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        key: Key("dateRangePickerButtonKey"),
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