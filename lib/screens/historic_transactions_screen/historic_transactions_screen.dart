import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'cubits/date_range_cubit.dart';
import 'cubits/filter_button_cubit.dart';
import 'widgets/historic_transactions_screen_body.dart';

class HistoricTransactionsScreen extends StatefulWidget {
  final TransactionRepository _transactionRepository;

  const HistoricTransactionsScreen({required TransactionRepository transactionRepository, Key? key})
    : _transactionRepository = transactionRepository,
      super(key: key);

  @override
  State<HistoricTransactionsScreen> createState() => _HistoricTransactionsScreenState();
}

class _HistoricTransactionsScreenState extends State<HistoricTransactionsScreen> with AutomaticKeepAliveClientMixin<HistoricTransactionsScreen> {
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FilterButtonCubit>(
            create: (_) => FilterButtonCubit(),
          ),
          BlocProvider<DateRangeCubit>(
            create: (_) => DateRangeCubit(),
          )
        ],
        child: HistoricTransactionsScreenBody(transactionRepository: widget._transactionRepository)
      )
    );
  }
}