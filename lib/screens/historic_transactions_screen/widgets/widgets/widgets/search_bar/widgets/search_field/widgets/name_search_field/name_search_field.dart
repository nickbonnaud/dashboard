import 'package:dashboard/resources/helpers/cupertino_box_decoration.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/historic_transactions_screen/widgets/bloc/transactions_list_bloc.dart';
import 'package:dashboard/theme/main_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'bloc/name_search_field_bloc.dart';

class NameSearchField extends StatefulWidget {

  @override
  State<NameSearchField> createState() => _NameSearchFieldState();
}

class _NameSearchFieldState extends State<NameSearchField> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  late NameSearchFieldBloc _nameSearchFieldBloc;
  
  @override
  void initState() {
    super.initState();
    _nameSearchFieldBloc = BlocProvider.of<NameSearchFieldBloc>(context);

    _firstNameController.addListener(_onNameChanged);
    _lastNameController.addListener(_onNameChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionsListBloc, TransactionsListState>(
      listenWhen: (previousState, state) => previousState.currentFilter != state.currentFilter,
      listener: (_, __) => _clearFormFields(),
      child: _nameFields()
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Widget _nameFields() {
    return ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
      ? _lastNameTextField()
      : ResponsiveRowColumn(
          rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(MOBILE),
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          columnMainAxisSize: MainAxisSize.min,
          columnSpacing: SizeConfig.getHeight(3),
          rowSpacing: SizeConfig.getWidth(1),
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _firstNameTextField()
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _lastNameTextField()
            )
          ],
        );
  }

  Widget _firstNameTextField() {
    return BlocBuilder<NameSearchFieldBloc, NameSearchFieldState>(
      builder: (context, state) {
        return CupertinoTextField(
          key: Key("firstNameSearchFieldKey"),
          decoration: CupertinoBoxDecoration.validator(isValid: (state.isFirstNameValid || _firstNameController.text.isEmpty)),
          cursorColor: Colors.black,
          textCapitalization: TextCapitalization.words,
          placeholder: "First",
          style: MainTheme.getDefaultFont().copyWith(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _firstNameController,
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _firstNameFocus.unfocus(),
          autocorrect: false,
        );
      }
    );
  }

  Widget _lastNameTextField() {
    return BlocBuilder<NameSearchFieldBloc, NameSearchFieldState>(
      builder: (context, state) {
        return CupertinoTextField(
          key: Key("lastNameSearchFieldKey"),
          decoration: CupertinoBoxDecoration.validator(isValid: (state.isLastNameValid || _lastNameController.text.isEmpty)),
          cursorColor: Colors.black,
          textCapitalization: TextCapitalization.words,
          placeholder: "Last",
          style: MainTheme.getDefaultFont().copyWith(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _lastNameController,
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _lastNameFocus.unfocus(),
          autocorrect: false,
        );
      }
    );
  }

  void _onNameChanged() {
    _nameSearchFieldBloc.add(NameChanged(firstName: _firstNameController.text, lastName: _lastNameController.text));
  }

  void _clearFormFields() {
    _nameSearchFieldBloc.add(Reset());
    _firstNameController.text = "";
    _lastNameController.text = "";
  }
}