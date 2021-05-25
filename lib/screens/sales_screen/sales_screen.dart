import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/date_range_cubit.dart';
import 'widgets/sales_screen_body.dart';

class SalesScreen extends StatefulWidget {
  final TransactionRepository _transactionRepository;

  const SalesScreen({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository;
  
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> with AutomaticKeepAliveClientMixin<SalesScreen> {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocProvider<DateRangeCubit>(
        create: (_) => DateRangeCubit(),
        child: SalesScreenBody(transactionRepository: widget._transactionRepository),
      ),
    );
  }
}