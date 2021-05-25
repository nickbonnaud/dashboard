import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/sales_screen/cubit/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class SalesHeader extends StatelessWidget {

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
    return Text3(text: "Today's Sales", context: context);
  }

  Widget _dateRangeHeader({required BuildContext context, required DateTimeRange dateRange}) {
    return Row(
      key: Key("dateRangeHeaderKey"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text5(
          text: "${DateFormatter.toStringDate(date: dateRange.start)} - ${DateFormatter.toStringDate(date: dateRange.end)}",
          context: context
        ),
        IconButton(
          key: Key("clearDatesButtonKey"),
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
}