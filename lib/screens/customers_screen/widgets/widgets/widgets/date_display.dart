import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/customers_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateDisplay extends StatelessWidget {

  const DateDisplay({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DateRangeCubit, DateTimeRange?>(
        builder: (context, dateRange) {
          if (dateRange == null) return Container();

          return Row(
            key: const Key("datesRowKey"),
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
      )
    );
  }
}