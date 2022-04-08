import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/date_range_cubit.dart';
import 'cubits/tips_screen_cubit.dart';
import 'widgets/tips_screen_body.dart';

class TipsScreen extends StatefulWidget {
  final TipsRepository _tipsRepository;
  final TransactionRepository _transactionRepository;
  
  const TipsScreen({
    required TipsRepository tipsRepository,
    required TransactionRepository transactionRepository,
    Key? key
  })
    : _tipsRepository = tipsRepository,
      _transactionRepository = transactionRepository,
      super(key: key);
  
  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> with AutomaticKeepAliveClientMixin<TipsScreen> {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<DateRangeCubit>(
            create: (_) => DateRangeCubit(),
          ),
          BlocProvider<TipsScreenCubit>(
            create: (_) => TipsScreenCubit(),
          ),
        ], 
        child: TipsScreenBody(tipsRepository: widget._tipsRepository, transactionRepository: widget._transactionRepository)
      )
    );
  }
}