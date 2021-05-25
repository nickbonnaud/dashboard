import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/tips_screen/cubits/tips_screen_cubit.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'widgets/employee_tip_finder/employee_tip_finder.dart';
import 'widgets/employee_tips_header.dart';
import 'widgets/employee_tips_list/bloc/employee_tips_list_bloc.dart';
import 'widgets/employee_tips_list/employee_tips_list.dart';
import 'widgets/total_tips/bloc/total_tips_bloc.dart';
import 'widgets/total_tips/total_tips.dart';

class TipsScreenBody extends StatelessWidget {
  final TipsRepository _tipsRepository;
  final TransactionRepository _transactionRepository;

  const TipsScreenBody({required TipsRepository tipsRepository, required TransactionRepository transactionRepository})
    : _tipsRepository = tipsRepository,
      _transactionRepository = transactionRepository;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(context: context),
        _changeDateButton(context: context),
        _toggleSearchButton(context: context)
      ],
    );
  }

  Widget _body({required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: SizeConfig.getHeight(1)),
          EmployeeTipsHeader(),
          SizedBox(height: SizeConfig.getHeight(3)),
          Expanded(
            child: BlocBuilder<TipsScreenCubit, bool>(
              builder: (context, isListVisible) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<EmployeeTipsListBloc>(
                      create: (context) => EmployeeTipsListBloc(
                        dateRangeCubit: context.read<DateRangeCubit>(),
                        tipsRepository: _tipsRepository
                      )..add(InitTipList())
                    ),
                    
                    BlocProvider<TotalTipsBloc>(
                      create: (context) => TotalTipsBloc(
                        dateRangeCubit: context.read<DateRangeCubit>(),
                        transactionRepository: _transactionRepository
                      )..add(InitTotal())
                    ),

                    BlocProvider<EmployeeTipFinderBloc>(
                      create: (context) => EmployeeTipFinderBloc(
                        dateRangeCubit: context.read<DateRangeCubit>(),
                        tipsRepository: _tipsRepository
                      )
                    )
                  ], 
                  child: ResponsiveRowColumn(
                    rowMainAxisSize: MainAxisSize.min,
                    rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(TABLET),
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    columnMainAxisSize: MainAxisSize.max,
                    columnSpacing: SizeConfig.getHeight(1),
                    rowSpacing: SizeConfig.getWidth(1),
                    children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        rowFit: FlexFit.loose,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TotalTips(),
                              _employeeTipFinder(context: context, isListVisible: isListVisible)
                            ],
                          ),
                        )
                      ),
                      _tipsListItem(context: context, isListVisible: isListVisible)
                    ],
                  )
                );
              },
            )
          )
        ],
      ),
    );
  }

  ResponsiveRowColumnItem _tipsListItem({required BuildContext context, required bool isListVisible}) {
    return ResponsiveRowColumnItem(
      rowFlex: 1,
      rowFit: FlexFit.loose,
      columnFit: FlexFit.loose,
      child: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
        ? isListVisible
          ? Column(
              children: [
                Text4(text: "All Employee Tips", context: context),
                SizedBox(height: SizeConfig.getHeight(1)),
                Expanded(child: EmployeeTipsList()) 
              ],
            )
          : Container()
        : Column(
            children: [
              Text4(text: "All Employee Tips", context: context),
              SizedBox(height: SizeConfig.getHeight(1)),
              Expanded(child: EmployeeTipsList()) 
            ],
          )
    );
  }

  Widget _employeeTipFinder({required BuildContext context, required bool isListVisible}) {
    return ResponsiveWrapper.of(context).isSmallerThan(TABLET)
      ? isListVisible
        ? Container()
        : EmployeeTipFinder()
      : EmployeeTipFinder();
  }

  Widget _changeDateButton({required BuildContext context}) {
    return Positioned(
      bottom: SizeConfig.getHeight(5),
      right: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        key: Key("changeDateButtonKey"),
        backgroundColor: Theme.of(context).colorScheme.callToAction,
        child: Icon(Icons.date_range),
        onPressed: () => _showDateRangePicker(context: context),
      )
    );
  }

  Widget _toggleSearchButton({required BuildContext context}) {
    if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET)) return Container();

    return Positioned(
      bottom: SizeConfig.getHeight(5),
      left: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        key: Key("toggleSearchButtonKey"),
        backgroundColor: Theme.of(context).colorScheme.callToAction,
        child: BlocBuilder<TipsScreenCubit, bool>(
          builder: (context, isListVisible) => isListVisible
            ? Icon(Icons.search)
            : Icon(Icons.list),
        ) ,
        onPressed: () => context.read<TipsScreenCubit>().toggle(),
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