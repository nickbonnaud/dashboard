import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/unassigned_transaction_widget.dart';
import 'bloc/unassigned_transactions_list_bloc.dart';

class UnassignedTransactionsList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UnassignedTransactionsListState();
}

class _UnassignedTransactionsListState extends State<UnassignedTransactionsList> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200;

  late UnassignedTransactionsListBloc _listBloc;

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<UnassignedTransactionsListBloc>(context);
    _scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnassignedTransactionsListBloc, UnassignedTransactionsListState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) return _error(error: state.errorMessage);
        if (state.transactions.isEmpty) return state.loading ? _loading() : _noTransactionsFound();

        return _transactions(state: state);
      }
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _transactions({required UnassignedTransactionsListState state}) {
    return ListView.builder(
      key: Key("unassignedTransactionsListKey"),
      shrinkWrap: true,
      controller: _scrollController,
      itemBuilder: (context, index) => index >= state.transactions.length
        ? BottomLoader()
        : UnassignedTransactionWidget(unassignedTransaction: state.transactions[index], index: index),
      itemCount: state.hasReachedEnd
        ? state.transactions.length
        : state.transactions.length + 1,
    );
  }

  Widget _error({required String error}) {
    return Center(
      child: Column(
        children: [
          Text4(text: "Error: $error", context: context, color: Theme.of(context).colorScheme.error),
          Text4(text: "Please try again", context: context, color: Theme.of(context).colorScheme.error)
        ],
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _noTransactionsFound() {
    return Center(
      child:  BoldText5(text: "No Transactions Found!", context: context),
    );
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (!_listBloc.state.paginating && maxScroll - currentScroll <= _scrollThreshold) {
      _listBloc.add(FetchMore());
    }
  }
}