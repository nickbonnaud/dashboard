import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/id_search_field/bloc/id_search_field_bloc.dart';
import 'widgets/id_search_field/id_search_field.dart';
import 'widgets/name_search_field/bloc/name_search_field_bloc.dart';
import 'widgets/name_search_field/name_search_field.dart';

class SearchField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundsListBloc, RefundsListState>(
      builder: (context, state) => _textField(context: context, state: state)
    );
  }

  Widget _textField({required BuildContext context, required RefundsListState state}) {
    Widget textField;
    switch (state.currentFilter) {
      case FilterType.refundId:
      case FilterType.transactionId:
      case FilterType.customerId:
        textField = BlocProvider<IdSearchFieldBloc>(
          create: (_) => IdSearchFieldBloc(
            refundsListBloc: BlocProvider.of<RefundsListBloc>(context),
            filterButtonCubit: context.read<FilterButtonCubit>()
          ),
          child: IdSearchField(currentFilter: state.currentFilter),
        );
        break;
      case FilterType.customerName:
        textField = BlocProvider<NameSearchFieldBloc>(
          create: (_) => NameSearchFieldBloc(
            refundsListBloc: BlocProvider.of<RefundsListBloc>(context)
          ),
          child: NameSearchField(),
        );
        break;
      default:
        textField = Container();
    }
    return textField;
  }
}