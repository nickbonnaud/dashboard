import 'package:dashboard/resources/helpers/cupertino_box_decoration.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'package:dashboard/theme/main_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'bloc/name_field_bloc.dart';

class NameField extends StatefulWidget {

  const NameField({Key? key})
    : super(key: key);

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  late NameFieldBloc _nameFieldBloc;
  
  @override
  void initState() {
    super.initState();
    _nameFieldBloc = BlocProvider.of<NameFieldBloc>(context);

    _firstNameController = TextEditingController(
      text: BlocProvider.of<EmployeeTipFinderBloc>(context).employeeFirstName
    );

    _lastNameController = TextEditingController(
      text: BlocProvider.of<EmployeeTipFinderBloc>(context).employeeLastName
    );

    
    _firstNameController.addListener(_onNameChanged);
    _lastNameController.addListener(_onNameChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
        ? _lastNameTextField()
        : ResponsiveRowColumn(
            layout: _layoutHelper.setLayout(context: context, deviceSize: MOBILE),
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
          ),
    );
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _firstNameController.dispose();

    _lastNameController.dispose();
    _lastNameFocus.dispose();
    
    _nameFieldBloc.close();
    super.dispose();
  }

  Widget _firstNameTextField() {
    return BlocBuilder<NameFieldBloc, NameFieldState>(
      builder: (context, state) {
        return CupertinoTextField(
          key: const Key("firstNameTextFieldKey"),
          decoration: CupertinoBoxDecoration.validator(isValid: (state.isFirstNameValid || state.firstName.isEmpty)),
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
    return BlocBuilder<NameFieldBloc, NameFieldState>(
      builder: (context, state) {
        return CupertinoTextField(
          key: const Key("lastNameTextFieldKey"),
          decoration: CupertinoBoxDecoration.validator(isValid: (state.isLastNameValid || state.lastName.isEmpty)),
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
    _nameFieldBloc.add(NameChanged(firstName: _firstNameController.text, lastName: _lastNameController.text));
  }
}