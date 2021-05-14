import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'widgets/date_range_picker.dart';
import 'widgets/filter_button.dart';
import 'widgets/search_field/search_field.dart';

class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: DateRangePicker(),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      floating: true,
      snap: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SearchField()
          ),
          FilterButton()
        ],
      ),
    );
  }
}