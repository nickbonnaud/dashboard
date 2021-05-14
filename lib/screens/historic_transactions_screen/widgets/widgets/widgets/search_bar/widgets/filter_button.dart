import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {

  final List<TransactionFilter> _filterOptions = [
    TransactionFilter(value: FilterType.transactionId, title: "Transaction ID"),
    TransactionFilter(value: FilterType.status, title: "Transaction Status"),
    TransactionFilter(value: FilterType.customerId, title: "Customer ID"),
    TransactionFilter(value: FilterType.customerName, title: "Customer Name"),
    TransactionFilter(value: FilterType.employeeName, title: "Employee Name"),
    TransactionFilter(value: FilterType.all, title: "Reset")
  ];
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterType>(
      icon: Icon(
        Icons.filter_list,
        color: Theme.of(context).colorScheme.callToAction,
        size: FontSizeAdapter.setSize(size: 4, context: context),
      ),
      itemBuilder: (context) => _filterOptions.map((option) => PopupMenuItem(
          key: Key(option.value.toString()),
          value: option.value,
          child: Text(option.title)
        )).toList(),
      onSelected: (filter) => _changeFilter(context: context, filter: filter)
    );
  }

  void _changeFilter({required BuildContext context, required FilterType filter}) {
    context.read<FilterButtonCubit>().filterChanged(filter: filter);
  }
}