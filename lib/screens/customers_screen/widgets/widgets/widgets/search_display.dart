import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/customers_screen/bloc/filter_button_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/filter_button.dart';

class SearchDisplay extends StatelessWidget {

  const SearchDisplay({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      floating: true,
      snap: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _header()
          ),
          const FilterButton()
        ],
      ),
    );
  }

  Widget _header() {
    return BlocBuilder<FilterButtonBloc, FilterButtonState>(
      builder: (context, state) {
        final String activeText = state.searchHistoric
          ? "Previous Customers"
          : "Active Customers";
        final String withTransactionsText = state.withTransactions
          ? "With Transactions"
          : "Without Transactions";
        return Column(
          children: [
            Text5(text: activeText, context: context),
            Text5(text: withTransactionsText, context: context)
          ],
        );
      }
    );
  }
}