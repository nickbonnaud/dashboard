import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/screens/customers_screen/bloc/filter_button_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {

  final List<String> _options = ["historic", "withTransaction"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterButtonBloc, FilterButtonState>(
      builder: (context, state) {
        return PopupMenuButton(
          key: Key("filterButtonKey"),
          icon: Icon(
            Icons.filter_list,
            color: Theme.of(context).colorScheme.callToAction,
            size: FontSizeAdapter.setSize(size: 4, context: context),
          ),
          itemBuilder: (context) => _options.map((option) {
            return PopupMenuItem<String>(
              value: option,
              child: Row(
                children: [
                Checkbox(
                  key: Key(option),
                    value: _setValue(option: option, state: state), 
                    onChanged: (value) {
                      _changeValue(option: option, context: context);
                      Navigator.of(context).pop();
                    }
                  ),
                  Text(_setTitle(option: option))
                ],
              ),
            );
          }).toList(),
          onSelected: (String option) => _changeValue(option: option, context: context),
        );
      }
    );
  }

  bool _setValue({required String option, required FilterButtonState state}) {
    final bool value = option == 'historic'
      ? state.searchHistoric
      : state.withTransactions;
    return value;
  }

  String _setTitle({required String option}) {
    return option == 'historic'
      ? "Previous"
      : "Transactions";
  }

  void _changeValue({required String option, required BuildContext context}) {
    option == 'historic'
      ? BlocProvider.of<FilterButtonBloc>(context).add(SearchHistoricChanged())
      : BlocProvider.of<FilterButtonBloc>(context).add(WithTransactionsChanged());
  }
}