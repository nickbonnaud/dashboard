import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/screens/historic_transactions_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/widgets/widgets/search_bar/widgets/search_field/bloc/transaction_statuses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/id_search_field/bloc/id_search_field_bloc.dart';
import 'widgets/id_search_field/id_search_field.dart';
import 'widgets/name_search_field/bloc/name_search_field_bloc.dart';
import 'widgets/name_search_field/name_search_field.dart';
import 'widgets/status_search_field.dart';

class SearchField extends StatelessWidget {

  const SearchField({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsListBloc, TransactionsListState>(
      builder: (context, state) {
        return _textField(context: context, listState: state);
      }
    );
  }

  Widget _textField({required BuildContext context, required TransactionsListState listState}) {
    return BlocBuilder<TransactionStatusesBloc, TransactionStatusesState>(
      buildWhen: (_, __) => false,
      builder: (context, state) {
        return _setTextField(context: context, listState: listState);
      }
    );
  }

  Widget _setTextField({required BuildContext context, required TransactionsListState listState}) {
    Widget textField;
    switch (listState.currentFilter) {
      case FilterType.status:
        textField = const StatusSearchField();
        break;
      case FilterType.customerId:
      case FilterType.transactionId:
        textField = BlocProvider<IdSearchFieldBloc>(
          create: (_) => IdSearchFieldBloc(
            transactionsListBloc: BlocProvider.of<TransactionsListBloc>(context),
            filterButtonCubit: context.read<FilterButtonCubit>()
          ),
          child: IdSearchField(currentFilter: listState.currentFilter),
        );
        break;
      case FilterType.customerName:
      case FilterType.employeeName:
        textField = BlocProvider<NameSearchFieldBloc>(
          create: (_) => NameSearchFieldBloc(
            transactionsListBloc: BlocProvider.of<TransactionsListBloc>(context),
            filterButtonCubit: context.read<FilterButtonCubit>()
          ),
          child: const NameSearchField(),
        );
        break;
      default:
        textField = Container();
    }
    return textField;
  }
}