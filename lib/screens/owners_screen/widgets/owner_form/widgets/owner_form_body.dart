import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/input_formatters.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:dashboard/screens/owners_screen/widgets/owner_form/bloc/owner_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:dashboard/theme/global_colors.dart';

class OwnerFormBody extends StatefulWidget {
  final OwnerAccount? _ownerAccount;

  const OwnerFormBody({OwnerAccount? ownerAccount, Key? key})
    : _ownerAccount = ownerAccount,
      super(key: key);

  @override
  State<OwnerFormBody> createState() => _OwnerFormBodyState();
}

class _OwnerFormBodyState extends State<OwnerFormBody> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _percentOwnershipFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _ssnFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _addressSecondaryFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _zipFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = ResponsiveLayoutHelper();

  final MaskTextInputFormatter _phoneFormatter = InputFormatters.phone();
  final MaskTextInputFormatter _dateFormatter = InputFormatters.date();
  final MaskTextInputFormatter _ssnFormatter = InputFormatters.ssn();
  final MaskTextInputFormatter _percentOwnershipFormatter = InputFormatters.setLengthDigits(numberDigits: 3);
  final MaskTextInputFormatter _stateFormatter = InputFormatters.setLengthAlpha(numberAlpha: 2);
  final MaskTextInputFormatter _zipFormatter = InputFormatters.setLengthDigits(numberDigits: 5);

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _percentOwnershipController;
  late TextEditingController _dobController;
  late TextEditingController _ssnController;
  late TextEditingController _addressController;
  late TextEditingController _addressSecondaryController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  late OwnerFormBloc _ownerFormBloc;

 bool get _isFormPopulated => 
   _addressController.text.isNotEmpty &&
   _cityController.text.isNotEmpty &&
   _stateController.text.isNotEmpty &&
   _zipController.text.isNotEmpty &&
   _firstNameController.text.isNotEmpty &&
   _lastNameController.text.isNotEmpty &&
   _titleController.text.isNotEmpty &&
   _phoneController.text.isNotEmpty &&
   _emailController.text.isNotEmpty &&
   _percentOwnershipController.text.isNotEmpty &&
   _dobController.text.isNotEmpty &&
   _ssnController.text.isNotEmpty;
 
 @override
  void initState() {
    super.initState();
    _ownerFormBloc = BlocProvider.of<OwnerFormBloc>(context);

    _firstNameController = TextEditingController(text: widget._ownerAccount?.firstName ?? "");
    _lastNameController = TextEditingController(text: widget._ownerAccount?.lastName ?? "");
    _titleController = TextEditingController(text: widget._ownerAccount?.title ?? "");
    _phoneController = TextEditingController(text: widget._ownerAccount?.phone ?? "");
    _emailController = TextEditingController(text: widget._ownerAccount?.email ?? "");
    _percentOwnershipController = TextEditingController(text: widget._ownerAccount?.percentOwnership == null ? "" : widget._ownerAccount?.percentOwnership.toString());
    _dobController = TextEditingController(text: widget._ownerAccount?.dob ?? "");
    _ssnController = TextEditingController(text: widget._ownerAccount?.ssn ?? "");
    _addressController = TextEditingController(text: widget._ownerAccount?.address.address ?? "");
    _addressSecondaryController = TextEditingController(text: widget._ownerAccount?.address.addressSecondary ?? "");
    _cityController = TextEditingController(text: widget._ownerAccount?.address.city ?? "");
    _stateController = TextEditingController(text: widget._ownerAccount?.address.state ?? "");
    _zipController = TextEditingController(text: widget._ownerAccount?.address.zip ?? "");

    if (widget._ownerAccount != null) {
      _ownerFormBloc.add(PrimaryChanged(isPrimary: widget._ownerAccount!.primary));
    }

    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _titleController.addListener(_onTitleChanged);
    _phoneController.addListener(_onPhoneChanged);
    _emailController.addListener(_onEmailChanged);
    _percentOwnershipController.addListener(_onPercentOwnershipChanged);
    _dobController.addListener(_onDobChanged);
    _ssnController.addListener(_onSsnChanged);
    _addressController.addListener(_onAddressChanged);
    _addressSecondaryController.addListener(_onAddressSecondaryChanged);
    _cityController.addListener(_onCityChanged);
    _stateController.addListener(_onStateChanged);
    _zipController.addListener(_onZipChanged);
  }
 
 @override
  Widget build(BuildContext context) {
    return BlocListener<OwnerFormBloc, OwnerFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<OwnersScreenBloc>(context).add(HideForm());
        }
      },
      child: Form(
        child: Column(
          children: [
            _title(context: context),
            SizedBox(height: SizeConfig.getHeight(5)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(5),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  rowFit:FlexFit.tight,
                  child: _firstNameTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  rowFit:FlexFit.tight,
                  child: _lastNameTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _titleTextField()
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(5)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(3),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _emailTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _phoneTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _percentOwnershipTextField()
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(5)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(3),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _ssnTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _dobTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  rowFit:FlexFit.tight,
                  child: _primaryCheckBox()
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(5)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(3),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _addressTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _addressSecondaryTextField()
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(5)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(3),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  rowFit:FlexFit.tight,
                  child: _cityTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit:FlexFit.tight,
                  child: _stateTextField()
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 2,
                  rowFit:FlexFit.tight,
                  child: _zipTextField()
                ),
              ],
            ),
            _errorMessage(),
            SizedBox(height: SizeConfig.getHeight(5)),
            Row(
              children: [
                SizedBox(width: SizeConfig.getWidth(10)),
                _buttons(),
                SizedBox(width: SizeConfig.getWidth(10)),
              ],
            )
          ],
        ),
      )
    );
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocus.dispose();

    _lastNameController.dispose();
    _lastNameFocus.dispose();

    _titleController.dispose();
    _titleFocus.dispose();

    _phoneController.dispose();
    _phoneFocus.dispose();

    _emailController.dispose();
    _emailFocus.dispose();

    _percentOwnershipController.dispose();
    _percentOwnershipFocus.dispose();

    _dobController.dispose();
    _dobFocus.dispose();

    _ssnController.dispose();
    _ssnFocus.dispose();

    _addressController.dispose();
    _addressFocus.dispose();

    _addressSecondaryController.dispose();
    _addressSecondaryFocus.dispose();

    _cityController.dispose();
    _cityFocus.dispose();

    _stateController.dispose();
    _stateFocus.dispose();

    _zipController.dispose();
    _zipFocus.dispose();

    _ownerFormBloc.close();

    super.dispose();
  }

  Widget _title({required BuildContext context}) {
    return Center(
      child: Column(
        children: [
          BoldText3(text: 'Owner Details', context: context),
          Text4(text: "Only persons owning 25% or more of business.", context: context)
        ],
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl, 
          onAnimationComplete: () => _resetForm(context: context),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state, context: context) : null,
            child: _buttonChild(state: state, context: context),
          )
        );
      }
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return OutlinedButton(
          key: const Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: Text4(text: 'Cancel', context: context, color: state.isSubmitting 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          ),
        );
      },
    );
  }

  Widget _firstNameTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("firstNameFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _firstNameController,
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _firstNameFocus.unfocus(),
          validator: (_) => !state.isFirstNameValid && _firstNameController.text.isNotEmpty
            ? 'Invalid First Name'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _lastNameTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("lastNameFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _lastNameController,
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _lastNameFocus.unfocus(),
          validator: (_) => !state.isLastNameValid && _lastNameController.text.isNotEmpty
            ? 'Invalid Last Name'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _titleTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("titleFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Title i.e. CEO, Owner...',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _titleController,
          focusNode: _titleFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _titleFocus.unfocus(),
          validator: (_) => !state.isTitleValid && _titleController.text.isNotEmpty
            ? 'Invalid Title'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _emailTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("emailFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _emailFocus.unfocus(),
          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty
            ? 'Invalid Email'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }
  
  Widget _dobTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("dobFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _dobController,
          focusNode: _dobFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _dobFocus.unfocus(),
          validator: (_) => !state.isDobValid && _dobController.text.isNotEmpty
            ? 'Invalid Date of Birth'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_dateFormatter],
          onTap: () => _onDobTap(state: state),
        );
      }
    );
  }

  Widget _percentOwnershipTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("percentOwnershipFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            suffixText: '%',
            labelText: 'Percent Ownership',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _percentOwnershipController,
          focusNode: _percentOwnershipFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _percentOwnershipFocus.unfocus(),
          validator: (_) => !state.isPercentOwnershipValid && _percentOwnershipController.text.isNotEmpty
            ? 'Ownership by ALL owners must be less than 100%'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_percentOwnershipFormatter],
        );
      }
    );
  }

  Widget _phoneTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("phoneFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: 'Phone',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _phoneController,
          focusNode: _phoneFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _phoneFocus.unfocus(),
          validator: (_) => !state.isPhoneValid && _phoneController.text.isNotEmpty
            ? 'Invalid Phone Number'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_phoneFormatter],
        );
      }
    );
  }

  Widget _ssnTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("ssnKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: 'SSN',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _ssnController,
          focusNode: _ssnFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _ssnFocus.unfocus(),
          validator: (_) => !state.isSsnValid && _ssnController.text.isNotEmpty
            ? 'Invalid SSN'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_ssnFormatter],
        );
      }
    );
  }

  Widget _primaryCheckBox() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return CheckboxListTile(
          key: const Key("primaryCheckBoxKey"),
          contentPadding: EdgeInsets.only(top: SizeConfig.getHeight(1)),
          secondary: SizedBox(width: SizeConfig.getWidth(4)),
          title: Text(
            'Account Controller?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context),
              color: state.isPrimary 
                ? Theme.of(context).colorScheme.callToAction
                : Colors.black.withOpacity(0.6)
            ),
          ),
          subtitle: const Text('Signing Agent for Business'),
          value: widget._ownerAccount != null
            ? widget._ownerAccount!.primary != state.isPrimary ? state.isPrimary : widget._ownerAccount!.primary 
            : state.isPrimary,
          onChanged: (isPrimary) => _onPrimaryChanged(isPrimary: isPrimary),
        );
      },
    );
  }

  Widget _addressTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("addressFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Address Line 1',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _addressController,
          focusNode: _addressFocus,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _addressFocus.unfocus(),
          validator: (_) => !state.isAddressValid && _addressController.text.isNotEmpty
            ? 'Invalid Address'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _addressSecondaryTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("addressSecondaryFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Address Line 2 (optional)',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _addressSecondaryController,
          focusNode: _addressSecondaryFocus,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _addressSecondaryFocus.unfocus(),
          validator: (_) => !state.isAddressSecondaryValid && _addressSecondaryController.text.isNotEmpty
            ? 'Invalid Address'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      },
    );
  }

  Widget _cityTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("cityFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _cityController,
          focusNode: _cityFocus,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _cityFocus.unfocus(),
          validator: (_) => !state.isCityValid && _cityController.text.isNotEmpty
            ? 'Invalid City'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      },
    );
  }

  Widget _stateTextField() {    
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("stateFieldKey"),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'State',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _stateController,
          focusNode: _stateFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _stateFocus.unfocus(),
          validator: (_) => !state.isStateValid && _stateController.text.isNotEmpty
            ? 'Invalid State'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_stateFormatter],
        );
      },
    );
  }

  Widget _zipTextField() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("zipFieldKey"),
          decoration: InputDecoration(
            labelText: 'Zip',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _zipController,
          focusNode: _zipFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _zipFocus.unfocus(),
          validator: (_) => !state.isZipValid && _zipController.text.isNotEmpty
            ? 'Invalid Zip'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          inputFormatters: [_zipFormatter],
        );
      },
    );
  }
  
  Widget _errorMessage() {
    return BlocBuilder<OwnerFormBloc, OwnerFormState>(
      builder: (context, state) {
        if (state.errorMessage.isEmpty) return Container();

        return Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
          ],
        );
      },
    );
  }
  
  Widget _buttonChild({required OwnerFormState state, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  Widget _buttons() {
    return widget._ownerAccount != null
      ? Expanded(
        child: Row(
          children: [
            Expanded(child: _cancelButton()),
            const SizedBox(width: 20.0),
            Expanded(child: _submitButton())
          ]
        ),
      )
      : Expanded(child: _submitButton());
  }
  
  void _resetForm({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<OwnerFormBloc>(context).add(Reset()));
  }

  bool _buttonEnabled({required OwnerFormState state}) {
    return state.isFormValid && _isFormPopulated && !state.isSubmitting;
  }

  void _submitButtonPressed({required OwnerFormState state, required BuildContext context}) {
    if (_buttonEnabled(state: state)) {
      if (widget._ownerAccount != null) {
        BlocProvider.of<OwnerFormBloc>(context).add(Updated(
          identifier: widget._ownerAccount!.identifier,
          firstName: _firstNameController.text, 
          lastName: _lastNameController.text,
          title: _titleController.text, 
          phone: _phoneController.text, 
          email: _emailController.text, 
          primary: state.isPrimary, 
          percentOwnership: _percentOwnershipController.text, 
          dob: _dobController.text, 
          ssn: _ssnController.text, 
          address: _addressController.text, 
          addressSecondary: _addressSecondaryController.text, 
          city: _cityController.text, 
          state: _stateController.text, 
          zip: _zipController.text
        ));
      } else {
        BlocProvider.of<OwnerFormBloc>(context).add(Submitted(
          firstName: _firstNameController.text, 
          lastName: _lastNameController.text,
          title: _titleController.text, 
          phone: _phoneController.text, 
          email: _emailController.text, 
          primary: state.isPrimary, 
          percentOwnership: _percentOwnershipController.text, 
          dob: _dobController.text, 
          ssn: _ssnController.text, 
          address: _addressController.text, 
          addressSecondary: _addressSecondaryController.text, 
          city: _cityController.text, 
          state: _stateController.text, 
          zip: _zipController.text
        ));
      }
    }
  }

  void _onFirstNameChanged() {
    _ownerFormBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _ownerFormBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  void _onTitleChanged() {
    _ownerFormBloc.add(TitleChanged(title: _titleController.text));
  }

  void _onPhoneChanged() {
    _ownerFormBloc.add(PhoneChanged(phone: _phoneFormatter.getUnmaskedText()));
  }

  void _onEmailChanged() {
    _ownerFormBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPrimaryChanged({@required bool? isPrimary}) async {
    if (isPrimary != null) {
      if (isPrimary) {
        final OwnerAccount? previousPrimary = _previouslyAssignedPrimary();
        if (previousPrimary != null) {
          bool? changePrimary = await _showPrimaryChangedDialog();
          if (changePrimary != null && changePrimary) {
            _ownerFormBloc.add(PrimaryChanged(isPrimary: isPrimary));
            BlocProvider.of<OwnersScreenBloc>(context).add(PrimaryRemoved(account: previousPrimary));
          }
        } else {
          _ownerFormBloc.add(PrimaryChanged(isPrimary: isPrimary));
        }
      } else {
        _ownerFormBloc.add(PrimaryChanged(isPrimary: isPrimary));
      }
    }
  }

  void _onPercentOwnershipChanged() {
    if (_percentOwnershipController.text.isNotEmpty) {
      _ownerFormBloc.add(PercentOwnershipChanged(percentOwnership: int.parse(_percentOwnershipController.text)));
    }
  }

  void _onDobChanged() {
    final String dob = _dateFormatter.getMaskedText() == "" ? _dobController.text : _dateFormatter.getMaskedText();
    _ownerFormBloc.add(DobChanged(dob: dob));
  }

  void _onSsnChanged() {
    _ownerFormBloc.add(SsnChanged(ssn: _ssnFormatter.getUnmaskedText()));
  }

  void _onAddressChanged() {
    _ownerFormBloc.add(AddressChanged(address: _addressController.text));
  }

  void _onAddressSecondaryChanged() {
    _ownerFormBloc.add(AddressSecondaryChanged(addressSecondary: _addressSecondaryController.text));
  }

  void _onCityChanged() {
    _ownerFormBloc.add(CityChanged(city: _cityController.text));
  }

  void _onStateChanged() {
    _ownerFormBloc.add(StateChanged(state: _stateController.text));
  }

  void _onZipChanged() {
    _ownerFormBloc.add(ZipChanged(zip: _zipFormatter.getUnmaskedText()));
  }

  OwnerAccount? _previouslyAssignedPrimary() {
    final List<OwnerAccount> owners = BlocProvider.of<OwnersScreenBloc>(context).owners;
    try {
      return owners.firstWhere((owner) => owner.primary);
    } on StateError catch (_) {
      return null;
    }
  }
  
  Future<bool?> _showPrimaryChangedDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        key: const Key("changePrimaryDialogKey"),
        title: const Text('Account Controller Already Assigned!'),
        content: const Text('Are you sure you want to change the Account Controller?'),
        actions: [
          TextButton(
            key: const Key("cancelDialogButtonKey"),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.danger)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            key: const Key("confirmDialogButtonKey"),
            child: Text('Confirm', style: TextStyle(color: Theme.of(context).colorScheme.callToAction)),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      )
    );
  }

  void _onDobTap({required OwnerFormState state}) async {
    showDatePicker(
      helpText: "Date of Birth",
      cancelText: 'Cancel',
      confirmText: "Set",
      errorFormatText: "Incorrect Date Format",
      errorInvalidText: "Invalid Date",
      fieldLabelText: "DOB",
      context: context,
      initialDate: state.isDobValid &&  _dobController.text != "" ? DateFormat.yMd().parse(_dobController.text) : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        key: const Key("datePickerKey"),
        data: ThemeData.light(),
        child: child!,
      )
    ).then((dob) {
      if (dob != null) {
        _dobController.text = DateFormat.yMd().format(dob);
      }
    });
  }

  void _cancelButtonPressed() {
    BlocProvider.of<OwnersScreenBloc>(context).add(HideForm());
  }
}