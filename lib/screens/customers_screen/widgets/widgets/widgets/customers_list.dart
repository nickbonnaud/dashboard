import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/customers_list_bloc.dart';
import 'widgets/customer_widget.dart';

class CustomersList extends StatefulWidget {
  final ScrollController _scrollController;

  const CustomersList({required ScrollController scrollController})
    : _scrollController = scrollController;
  
  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  final double _scrollThreshold = 200;

  late CustomersListBloc _customersListBloc;

  @override
  void initState() {
    super.initState();
    _customersListBloc = BlocProvider.of<CustomersListBloc>(context);
    widget._scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersListBloc, CustomersListState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) return _error(error: state.errorMessage);
        if (state.customers.isEmpty) return state.loading ? _loading() : _noCustomers();

        return _customers(state: state);
      }
    );
  }

  Widget _customers({required CustomersListState state}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => index >= state.customers.length
          ? BottomLoader()
          : CustomerWidget(index: index, customerResource: state.customers[index]),
        childCount: state.hasReachedEnd
          ? state.customers.length
          : state.customers.length + 1
      ),
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

  Widget _noCustomers() {
    return SliverFillRemaining(
      child: Center(
        child: BoldText5(text: "No Customers Found!", context: context),
      ),
      hasScrollBody: false,
    );
  }

  void _onScroll() {
    final double maxScroll = widget._scrollController.position.maxScrollExtent;
    final double currentScroll = widget._scrollController.position.pixels;

    if (!BlocProvider.of<CustomersListBloc>(context).state.paginating && maxScroll - currentScroll <= _scrollThreshold) {
      _customersListBloc.add(FetchMore());
    }
  }
}