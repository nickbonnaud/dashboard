import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/date_range_cubit.dart';
import 'cubits/filter_button_cubit.dart';
import 'widgets/historic_refunds_screen_body.dart';

class HistoricRefundsScreen extends StatefulWidget {

  const HistoricRefundsScreen({Key? key})
    : super(key: key);

  @override
  State<HistoricRefundsScreen> createState() =>_HistoricRefundsScreenState();
}

class _HistoricRefundsScreenState extends State<HistoricRefundsScreen> with AutomaticKeepAliveClientMixin<HistoricRefundsScreen> {

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
        child: const HistoricRefundsScreenBody(),
      ),
    );
  }
}