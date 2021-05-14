import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/refunds_list_bloc.dart';
import 'widgets/historic_refunds_slivers.dart';

class HistoricRefundsScreenBody extends StatelessWidget {
  final RefundRepository _refundRepository;

  const HistoricRefundsScreenBody({required RefundRepository refundRepository})
    : _refundRepository = refundRepository;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RefundsListBloc>(
      create: (context) => RefundsListBloc(
        filterButtonCubit: BlocProvider.of<FilterButtonCubit>(context),
        dateRangeCubit: BlocProvider.of<DateRangeCubit>(context),
        refundRepository: _refundRepository
      )..add(Init()),
      child: HistoricRefundsSlivers(),
    );
  }
}