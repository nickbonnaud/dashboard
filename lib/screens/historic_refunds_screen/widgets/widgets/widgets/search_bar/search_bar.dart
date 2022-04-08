import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'widgets/date_range_picker.dart';
import 'widgets/filter_button.dart';
import 'widgets/search_field/search_field.dart';

class SearchBar extends StatelessWidget {
  
  const SearchBar({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: const DateRangePicker(),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      floating: true,
      snap: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Expanded(
            child: SearchField()
          ),
          FilterButton()
        ],
      ),
    );
  }
}