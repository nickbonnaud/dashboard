import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/search_bar/search_bar.dart';
import 'widgets/search_display.dart';
import 'widgets/transactions_list.dart';


class HistoricTransactionsSlivers extends StatefulWidget {

  const HistoricTransactionsSlivers({Key? key})
    : super(key: key);
  
  @override
  State<HistoricTransactionsSlivers> createState() => _HistoricTransactionsSliversState();
}

class _HistoricTransactionsSliversState extends State<HistoricTransactionsSlivers> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _searchDisplay(),
        _searchBar(),
        _transactionsList()
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _searchDisplay() {
    return SliverPadding(
      padding: _padding(),
      sliver: const SliverToBoxAdapter(
        child: SearchDisplay(),
      ),
    );
  }

  Widget _searchBar() {
    return SliverPadding(
      padding: _padding(),
      sliver: const SearchBar(),
    );
  }

  Widget _transactionsList() {
    return SliverPadding(
      padding: _padding(),
      sliver: TransactionsList(
        scrollController: _scrollController,
      ),
    );
  }

  EdgeInsetsGeometry _padding() {
    return ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
      ? EdgeInsets.only(left: SizeConfig.getWidth(10), right: SizeConfig.getWidth(10))
      : EdgeInsets.only(left: SizeConfig.getWidth(15), right: SizeConfig.getWidth(15));
  }
}