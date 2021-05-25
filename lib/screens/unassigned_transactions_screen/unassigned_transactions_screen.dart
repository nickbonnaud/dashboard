import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/date_range_cubit.dart';
import 'widgets/unassigned_transactions_screen_body.dart';

class UnassignedTransactionsScreen extends StatefulWidget {
  final UnassignedTransactionRepository _unassignedTransactionRepository;
  final PosAccount _posAccount;

  const UnassignedTransactionsScreen({
    required UnassignedTransactionRepository unassignedTransactionRepository,
    required PosAccount posAccount
  })
    : _unassignedTransactionRepository = unassignedTransactionRepository,
      _posAccount = posAccount;

  @override
  State<UnassignedTransactionsScreen> createState() => _UnassignedTransactionsScreenState();
}

class _UnassignedTransactionsScreenState extends State<UnassignedTransactionsScreen> with AutomaticKeepAliveClientMixin<UnassignedTransactionsScreen> {

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: BlocProvider<DateRangeCubit>(
        create: (_) => DateRangeCubit(),
        child: UnassignedTransactionsScreenBody(unassignedTransactionRepository: widget._unassignedTransactionRepository, posAccount: widget._posAccount,),
      ),
    );
  }
}