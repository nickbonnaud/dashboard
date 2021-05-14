import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/customers_screen/cubit/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class DateDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DateRangeCubit, DateTimeRange?>(
        builder: (context, dateRange) {
          if (dateRange == null) return Container();

          return Row(
            key: Key("datesRowKey"),
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
                  size: FontSizeAdapter.setSize(size: 2, context: context),
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