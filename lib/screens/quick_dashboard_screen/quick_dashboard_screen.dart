import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/last_month/net_sales_month_bloc/net_sales_month_bloc.dart';
import 'blocs/last_month/total_refunds_month_bloc/total_refunds_month_bloc.dart';
import 'blocs/last_month/total_sales_month_bloc/total_sales_month_bloc.dart';
import 'blocs/last_month/total_taxes_month_bloc/total_taxes_month_bloc.dart';
import 'blocs/last_month/total_tips_month_bloc/total_tips_month_bloc.dart';
import 'blocs/last_month/total_transactions_month_bloc/total_transactions_month_bloc.dart';
import 'blocs/last_month/total_unique_customers_month_bloc/total_unique_customers_month_bloc.dart';
import 'blocs/recent_transactions_bloc/recent_transactions_bloc.dart';
import 'blocs/today/net_sales_today_bloc/net_sales_today_bloc.dart';
import 'blocs/today/total_refunds_today_bloc/total_refunds_today_bloc.dart';
import 'blocs/today/total_sales_today_bloc/total_sales_today_bloc.dart';
import 'blocs/today/total_tips_today_bloc/total_tips_today_bloc.dart';
import 'widgets/quick_dashboard_body.dart';

class QuickDashboardScreen extends StatefulWidget {

  const QuickDashboardScreen({Key? key})
    : super(key: key);
  
  @override
  State<QuickDashboardScreen> createState() => _QuickDashboardScreenState();
}

class _QuickDashboardScreenState extends State<QuickDashboardScreen> with AutomaticKeepAliveClientMixin<QuickDashboardScreen> {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.getWidth(1),
          right: SizeConfig.getWidth(1)
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NetSalesTodayBloc>(
              create: (_) => NetSalesTodayBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchNetSalesToday()),
            ),

            BlocProvider<TotalRefundsTodayBloc>(
              create: (_) => TotalRefundsTodayBloc(
                refundRepository: RepositoryProvider.of<RefundRepository>(context)
              )..add(FetchTotalRefundsToday())
            ),

            BlocProvider<TotalTipsTodayBloc>(
              create: (_) => TotalTipsTodayBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalTipsToday())
            ),

            BlocProvider<TotalSalesTodayBloc>(
              create: (_) => TotalSalesTodayBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalSalesToday()),
            ),

            BlocProvider<NetSalesMonthBloc>(
              create: (_) => NetSalesMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchNetSalesMonth()),
            ),

            BlocProvider<TotalTaxesMonthBloc>(
              create: (_) => TotalTaxesMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalTaxesMonth()),
            ),

            BlocProvider<TotalTipsMonthBloc>(
              create: (_) => TotalTipsMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalTipsMonth()),
            ),

            BlocProvider<TotalSalesMonthBloc>(
              create: (_) => TotalSalesMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalSalesMonth()),
            ),

            BlocProvider<TotalRefundsMonthBloc>(
              create: (_) => TotalRefundsMonthBloc(
                refundRepository: RepositoryProvider.of<RefundRepository>(context)
              )..add(FetchTotalRefundsMonth()),
            ),

            BlocProvider<TotalUniqueCustomersMonthBloc>(
              create: (_) => TotalUniqueCustomersMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalUniqueCustomersMonth()),
            ),

            BlocProvider<TotalTransactionsMonthBloc>(
              create: (_) => TotalTransactionsMonthBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(FetchTotalTransactionsMonth()),
            ),

            BlocProvider<RecentTransactionsBloc>(
              create: (_) => RecentTransactionsBloc(
                transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
              )..add(InitRecentTransactions())
            )
          ],
          child: const QuickDashboardBody()
          )
      ),
    );
  }
}