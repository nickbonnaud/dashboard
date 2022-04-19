import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../bloc/filter_button_bloc.dart';
import '../cubit/date_range_cubit.dart';
import 'bloc/customers_list_bloc.dart';
import 'widgets/customers_screen_slivers.dart';

class CustomersScreenBody extends StatelessWidget {

  const CustomersScreenBody({Key? key})
    : super(key: key);
  
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
    return BlocProvider<CustomersListBloc>(
      create: (context) => CustomersListBloc(
        customerRepository: RepositoryProvider.of<CustomerRepository>(context),
        dateRangeCubit: BlocProvider.of<DateRangeCubit>(context),
        filterButtonBloc: BlocProvider.of<FilterButtonBloc>(context)
      )..add(Init()),
      child: const CustomersScreenSlivers(),
    );
  }

  Widget _changeDateButton({required BuildContext context}) {
    return Positioned(
      bottom: SizeConfig.getHeight(5),
      right: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        key: const Key("datePickerButtonKey"),
        backgroundColor: Theme.of(context).colorScheme.callToAction,
        child: const Icon(Icons.date_range),
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
      helpText: dateRangeSet ? "Change Date Range" : "Select Date Range",
      cancelText: dateRangeSet ? "Clear" : "Cancel",
      confirmText: dateRangeSet ? "Change" : "Set",
      saveText: dateRangeSet ? "Change" : "Set",
      errorFormatText: "Incorrect Date Format",
      errorInvalidText: "Invalid Date",
      errorInvalidRangeText: "Invalid Date Range",
      fieldStartLabelText: "Start Date",
      fieldEndLabelText: "End Date",
      builder: (context, child) => Theme(
        key: const Key("dateRangePickerKey"),
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