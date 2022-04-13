import 'package:dashboard/providers/status_provider.dart';
import 'package:dashboard/repositories/status_repository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/date_range_picker.dart';
import 'widgets/filter_button.dart';
import 'widgets/search_field/bloc/transaction_statuses_bloc.dart';
import 'widgets/search_field/search_field.dart';

class SearchBar extends StatelessWidget {
  final StatusRepository _statusRepository = const StatusRepository(statusProvider: StatusProvider());

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
        children: [
          Expanded(
            child: BlocProvider<TransactionStatusesBloc>(
              create: (_) => TransactionStatusesBloc(
                statusRepository: _statusRepository
              )..add(InitStatuses()),
              child: const SearchField(),
            ),
          ),
          const FilterButton()
        ],
      ),
    );
  }
}