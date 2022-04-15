import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/tips_screen/cubits/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class EmployeeTipsHeader extends StatelessWidget {

  const EmployeeTipsHeader({Key? key})
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
    return Text3(text: "Recent Tip Totals", context: context);
  }

  Widget _dateRangeHeader({required BuildContext context, required DateTimeRange dateRange}) {
    return Row(
      key: const Key("dateRangeHeaderKey"),
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
            size: SizeConfig.getWidth(2),
          ),
          onPressed: () => context.read<DateRangeCubit>().dateRangeChanged(dateRange: null)
        )
      ],
    );
  }
}