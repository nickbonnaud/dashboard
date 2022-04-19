import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/date_range_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/refunds_list_bloc.dart';
import 'widgets/historic_refunds_slivers.dart';

class HistoricRefundsScreenBody extends StatelessWidget {

  const HistoricRefundsScreenBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RefundsListBloc>(
      create: (context) => RefundsListBloc(
        filterButtonCubit: BlocProvider.of<FilterButtonCubit>(context),
        dateRangeCubit: BlocProvider.of<DateRangeCubit>(context),
        refundRepository: RepositoryProvider.of<RefundRepository>(context)
      )..add(Init()),
      child: const HistoricRefundsSlivers(),
    );
  }
}