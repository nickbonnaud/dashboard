import 'package:dashboard/global_widgets/transaction_widget.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/recent_transactions_bloc/recent_transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class RecentTransactions extends StatelessWidget {

  const RecentTransactions({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoldText5(text: 'Recent Transactions', context: context),
        SizedBox(height: SizeConfig.getHeight(2)),
        BlocBuilder<RecentTransactionsBloc, RecentTransactionsState>(
          builder: (context, state) {
            if (state.errorMessage.isNotEmpty) return _error(context: context, error: state.errorMessage);
            if (state.transactions.isEmpty) return state.loading ? _loading(context: context) : _noTransactions(context: context);

            return _transactions(state: state);
          }
        )
      ],
    );
  }

  Widget _error({required BuildContext context, required String error}) {
    return Center(
      child: Text4(text: "Error: $error", context: context, color: Theme.of(context).colorScheme.error),
    );
  }

  Widget _loading({required BuildContext context}) {
    return Center(
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction)
    );
  }

  Widget _noTransactions({required BuildContext context}) {
    return Center(
      child: BoldText5(text: "No recent transactions.", context: context),
    );
  }

  Widget _transactions({required RecentTransactionsState state}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) => TransactionWidget(index: index, transactionResource: state.transactions[index])
    );
  }
}