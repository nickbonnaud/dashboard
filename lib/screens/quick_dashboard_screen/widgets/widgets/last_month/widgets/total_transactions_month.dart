import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_transactions_month_bloc/total_transactions_month_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class TotalTransactionsMonth extends StatelessWidget {

  const TotalTransactionsMonth({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Completed Transactions'),
      trailing: BlocBuilder<TotalTransactionsMonthBloc, TotalTransactionsMonthState>(
        builder: (context, state) {
          if (state is TotalTransactionsInitial || state is Loading) return CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction);
          if (state is FetchTotalTransactionsFailed) return _error(context: context);

          return Text4(text: (state as TotalTransactionsLoaded).totalTransactions.toString(), context: context);
        }
      ),
    );
  }

  Widget _error({required BuildContext context}) {
    return Icon(
      Icons.warning,
      color: Theme.of(context).colorScheme.danger,
    );
  }
}