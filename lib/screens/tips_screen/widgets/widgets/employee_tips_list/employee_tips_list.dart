import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../tip_card.dart';
import 'bloc/employee_tips_list_bloc.dart';

class EmployeeTipsList extends StatefulWidget {

  const EmployeeTipsList({Key? key})
    : super(key: key);

  @override
  State<EmployeeTipsList> createState() => _EmployeeTipsListState();
}

class _EmployeeTipsListState extends State<EmployeeTipsList> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.getWidth(1),
        right: SizeConfig.getWidth(1)
      ),
      child: BlocBuilder<EmployeeTipsListBloc, EmployeeTipsListState>(
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty) return _error(error: state.errorMessage);
          if (state.tips.isEmpty) return state.loading ? _loading() : _noTipsFound();
          return _tipsList(state: state);
        }
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction),
    );
  }

  Widget _noTipsFound() {
    return Center(
      child: BoldText5(text: "No Tips Found!", context: context),
    );
  }

  Widget _tipsList({required EmployeeTipsListState state}) {
    return ListView.builder(
      key: const Key("tipsListKey"),
      shrinkWrap: true,
      controller: _scrollController,
      itemBuilder: (context, index) => index >= state.tips.length
        ? const BottomLoader()
        : TipCard(employeeTip: state.tips[index]),
      itemCount: state.hasReachedEnd
        ? state.tips.length
        : state.tips.length + 1, 
    );
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<EmployeeTipsListBloc>(context).add(FetchMore());
    }
  }
}