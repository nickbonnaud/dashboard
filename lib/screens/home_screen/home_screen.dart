import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_screen_cubit.dart';
import 'widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  final TransactionRepository _transactionRepository;
  final RefundRepository _refundRepository;
  final TipsRepository _tipsRepository;
  final UnassignedTransactionRepository _unassignedTransactionRepository;
  final CustomerRepository _customerRepository;
  final PosAccount _posAccount;

  const HomeScreen({
    required TransactionRepository transactionRepository,
    required RefundRepository refundRepository,
    required TipsRepository tipsRepository,
    required UnassignedTransactionRepository unassignedTransactionRepository,
    required CustomerRepository customerRepository,
    required PosAccount posAccount,
    Key? key
  })
    : _transactionRepository = transactionRepository,
      _refundRepository = refundRepository,
      _tipsRepository = tipsRepository,
      _unassignedTransactionRepository = unassignedTransactionRepository,
      _customerRepository = customerRepository,
      _posAccount = posAccount,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenCubit>(
      create: (_) => HomeScreenCubit(),
      child: HomeScreenBody(
        transactionRepository: _transactionRepository,
        refundRepository: _refundRepository,
        tipsRepository: _tipsRepository,
        unassignedTransactionRepository: _unassignedTransactionRepository,
        customerRepository: _customerRepository,
        posAccount: _posAccount
      ),
    );
  }
}