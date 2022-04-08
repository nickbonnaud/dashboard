import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transaction_statuses_bloc.dart';

class StatusSearchField extends StatelessWidget {

  const StatusSearchField({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      key: const Key("statusPickerKey"),
      initialValue: null,
      builder: (FormFieldState<int>? formState) {
        return Container(
          color: CupertinoColors.white,
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            isEmpty: formState == null,
            child: DropdownButtonHideUnderline(
              child: BlocBuilder<TransactionStatusesBloc, TransactionStatusesState>(
                buildWhen: (previousState, currentState) {
                  return previousState.statuses != currentState.statuses;
                },
                builder: (context, state) {
                  return DropdownButton<int>(
                    hint: Text(
                      "Select Status",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: FontSizeAdapter.setSize(size: 2, context: context),
                        color: CupertinoColors.placeholderText
                      ),
                    ),
                    isDense: true,
                    onChanged: (statusCode) => _selectionChanged(context: context, formState: formState, statusCode: statusCode),
                    value: formState?.value,
                    items: state.statuses.map((status) {
                      return DropdownMenuItem(
                        key: Key("${status.code}Key"),
                        value: status.code,
                        child: Text(
                          status.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: FontSizeAdapter.setSize(size: 2, context: context),
                          ),
                        )
                      );
                    }).toList()
                  );
                }
              )
            )
          ),
        );
      }
    );
  }

  void _selectionChanged({required BuildContext context, @required FormFieldState<int>? formState, @required int? statusCode}) {
    if (formState != null && statusCode != null) {
      formState.didChange(statusCode);
      BlocProvider.of<TransactionsListBloc>(context).add(FetchByStatus(code: statusCode));
    }
  }
}