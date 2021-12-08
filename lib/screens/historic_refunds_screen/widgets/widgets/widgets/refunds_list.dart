import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/global_widgets/refund_widget.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class RefundsList extends StatefulWidget {
  final ScrollController _scrollController;

  const RefundsList({required ScrollController scrollController})
    : _scrollController = scrollController;

  @override
  State<RefundsList> createState() => _RefundsListState();
}

class _RefundsListState extends State<RefundsList> {
  final double _scrollThreshold = 200;

  late RefundsListBloc _refundsListBloc;

  @override
  void initState() {
    super.initState();
    _refundsListBloc = BlocProvider.of<RefundsListBloc>(context);
    widget._scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundsListBloc, RefundsListState>(
      builder: (context, state) {
        if (state.errorMessage.length > 0) return _error(error: state.errorMessage);
        if (state.refunds.length == 0) return state.loading ? _loading() : _noRefundsFound();
        return _refunds(state: state);
      }
    );
  }

  @override
  void dispose() {
    _refundsListBloc.close();
    super.dispose();
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

  Widget _noRefundsFound() {
    return SliverFillRemaining(
      child: Center(
        child: BoldText5(text: "No Refunds Found!", context: context),
      ),
      hasScrollBody: false,
    );
  }

  Widget _refunds({required RefundsListState state}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => index >= state.refunds.length
          ? BottomLoader()
          : RefundWidget(index: index, refundResource: state.refunds[index]),
        childCount: state.hasReachedEnd
          ? state.refunds.length
          : state.refunds.length + 1
      )
    );
  }

  void _onScroll() {
    final double maxScroll = widget._scrollController.position.maxScrollExtent;
    final double currentScroll = widget._scrollController.position.pixels;

    if (!BlocProvider.of<RefundsListBloc>(context).state.paginating && maxScroll - currentScroll <= _scrollThreshold) {
      _refundsListBloc.add(FetchMore());
    }
  }
}