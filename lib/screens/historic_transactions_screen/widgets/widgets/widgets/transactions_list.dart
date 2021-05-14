import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/global_widgets/transaction_widget.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class TransactionsList extends StatefulWidget {
  final ScrollController _scrollController;

  const TransactionsList({required ScrollController scrollController})
    : _scrollController = scrollController;
  
  @override
  State<StatefulWidget> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final double _scrollThreshold = 200;

  late TransactionsListBloc _transactionsListBloc;
  
  @override
  void initState() {
    super.initState();
    _transactionsListBloc = BlocProvider.of<TransactionsListBloc>(context);
    widget._scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsListBloc, TransactionsListState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) return _error(error: state.errorMessage);
        if (state.transactions.isEmpty) return state.loading ? _loading() : _noTransactionsFound();
        return _transactions(state: state);
      }
    );
  }

  Widget _transactions({required TransactionsListState state}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => index >= state.transactions.length
          ? BottomLoader()
          : TransactionWidget(index: index, transactionResource: state.transactions[index]),
        childCount: state.hasReachedEnd
          ? state.transactions.length
          : state.transactions.length + 1
      )
    );
  }
  
  Widget _error({required String error}) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          children: [
            Text4(text: "Error: $error", context: context, color: Theme.of(context).colorScheme.error),
            Text4(text: "Please try again", context: context, color: Theme.of(context).colorScheme.error)
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.callToAction,
        ),
      ),
      hasScrollBody: false,
    );
  }

  Widget _noTransactionsFound() {
    return SliverFillRemaining(
      child: Center(
        child: BoldText5(text: "No Transactions Found!", context: context),
      ),
      hasScrollBody: false,
    );
  }
  
  void _onScroll() {
    final double maxScroll = widget._scrollController.position.maxScrollExtent;
    final double currentScroll = widget._scrollController.position.pixels;

    if (!_transactionsListBloc.state.paginating && maxScroll - currentScroll <= _scrollThreshold) {
      _transactionsListBloc.add(FetchMoreTransactions());
    }
  }
}