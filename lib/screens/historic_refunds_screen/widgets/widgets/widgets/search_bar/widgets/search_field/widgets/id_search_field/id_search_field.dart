import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/resources/helpers/cupertino_box_decoration.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/input_formatters.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:dashboard/theme/main_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'bloc/id_search_field_bloc.dart';

class IdSearchField extends StatefulWidget {
  final FilterType _currentFilter;

  const IdSearchField({required FilterType currentFilter})
    : _currentFilter = currentFilter;

  @override
  State<IdSearchField> createState() => _IdSearchFieldState();
}

class _IdSearchFieldState extends State<IdSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final MaskTextInputFormatter _formatter = InputFormatters.uuid();

  @override
  void initState() {
    _controller.addListener(_onInputChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RefundsListBloc, RefundsListState>(
      listenWhen: (previousState, state) => previousState.currentFilter != state.currentFilter,
      listener: (_, __) => _clearField(),
      child: BlocBuilder<IdSearchFieldBloc, IdSearchFieldState>(
        builder: (context, state) {
          return CupertinoTextField(
            key: Key("idSearchFieldKey"),
            decoration: CupertinoBoxDecoration.validator(isValid: state.isFieldValid || _controller.text.isEmpty),
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.none,
            placeholder: _placeHolder(),
            style: MainTheme.getDefaultFont().copyWith(
              fontWeight: FontWeight.w700,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            inputFormatters: [_formatter],
            onSubmitted: (_) => _focusNode.unfocus(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _placeHolder() {
    return widget._currentFilter == FilterType.refundId
      ? "Refund ID"
      : widget._currentFilter == FilterType.transactionId
        ? "Transaction ID"
        : "Customer ID";
  }

  void _onInputChanged() {
    BlocProvider.of<IdSearchFieldBloc>(context).add(FieldChanged(id: _controller.text));
  }

  void _clearField() {
    _controller.text = "";
    _formatter.clear();
  }
}