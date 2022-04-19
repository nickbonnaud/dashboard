import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/transactions_list_bloc.dart';
import 'widgets/historic_transaction_slivers.dart';

class HistoricTransactionsScreenBody extends StatelessWidget {

  const HistoricTransactionsScreenBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsListBloc>(
      create: (context) => TransactionsListBloc(
        filterButtonCubit: BlocProvider.of<FilterButtonCubit>(context),
        dateRangeCubit: BlocProvider.of<DateRangeCubit>(context),
        transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
      )..add(Init()),
      child: const HistoricTransactionsSlivers(),
    );
  }
}