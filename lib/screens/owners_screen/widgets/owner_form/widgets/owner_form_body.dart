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

  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();

  late TextEditingController _dobController;
  
  late MaskTextInputFormatter _phoneFormatter;
  late MaskTextInputFormatter _percentOwnershipFormatter;
  late MaskTextInputFormatter _ssnFormatter;
  late MaskTextInputFormatter _stateFormatter;
  late MaskTextInputFormatter _zipFormatter;

  late OwnerFormBloc _ownerFormBloc;
 
 @override
  void initState() {
    super.initState();
    _ownerFormBloc = BlocProvider.of<OwnerFormBloc>(context);
    
    _phoneFormatter = InputFormatters.phone(initial: widget._ownerAccount?.phone ?? "");
    _percentOwnershipFormatter = InputFormatters.setLengthDigits(numberDigits: 3, initial: widget._ownerAccount?.percentOwnership == null ? "" : widget._ownerAccount?.percentOwnership.toString());
    
    _dobController = TextEditingController(text: widget._ownerAccount?.dob ?? "");
    
    _ssnFormatter = InputFormatters.ssn(initial: widget._ownerAccount?.ssn ?? "");
    _stateFormatter = InputFormatters.setLengthAlpha(numberAlpha: 2, initial: widget._ownerAccount?.address.state ?? "");
    _zipFormatter = InputFormatters.setLengthDigits(numberDigits: 5, initial: widget._ownerAccount?.address.zip ?? "");

    if (widget._ownerAccount != null) {
      _ownerFormBloc.add(PrimaryChanged(isPrimary: widget._ownerAccount!.primary));
    }
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
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _titleFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _percentOwnershipFocus.dispose();
    _dobFocus.dispose();
    _ssnFocus.dispose();
    _addressFocus.dispose();
    _addressSecondaryFocus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
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
          initialValue: widget._ownerAccount?.firstName ?? "",
          onChanged: (firstName) => _onFirstNameChanged(firstName: firstName),
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _firstNameFocus.unfocus(),
          validator: (_) => !state.isFirstNameValid && state.firstName.isNotEmpty
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
          initialValue: widget._ownerAccount?.lastName ?? "",
          onChanged: (lastName) => _onLastNameChanged(lastName: lastName),
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _lastNameFocus.unfocus(),
          validator: (_) => !state.isLastNameValid && state.lastName.isNotEmpty
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
          initialValue: widget._ownerAccount?.title ?? "",
          onChanged: (title) => _onTitleChanged(title: title),
          focusNode: _titleFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _titleFocus.unfocus(),
          validator: (_) => !state.isTitleValid && state.title.isNotEmpty
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
          initialValue: widget._ownerAccount?.email ?? "",
          onChanged: (email) => _onEmailChanged(email: email),
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _emailFocus.unfocus(),
          validator: (_) => !state.isEmailValid && state.email.isNotEmpty
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
          readOnly: true,
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
          validator: (_) => !state.isDobValid && state.dob.isNotEmpty
            ? 'Invalid Date of Birth'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
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
          initialValue: _percentOwnershipFormatter.getMaskedText(),
          onChanged: (_) => _onPercentOwnershipChanged(),
          focusNode: _percentOwnershipFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _percentOwnershipFocus.unfocus(),
          validator: (_) => !state.isPercentOwnershipValid && state.percentOwnership.isNotEmpty
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
          initialValue: _phoneFormatter.getMaskedText(),
          onChanged: (_) => _onPhoneChanged(),
          focusNode: _phoneFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _phoneFocus.unfocus(),
          validator: (_) => !state.isPhoneValid && state.phone.isNotEmpty
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
          initialValue: _ssnFormatter.getMaskedText(),
          onChanged: (_) => _onSsnChanged(),
          focusNode: _ssnFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _ssnFocus.unfocus(),
          validator: (_) => !state.isSsnValid && state.ssn.isNotEmpty
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
          initialValue: widget._ownerAccount?.address.address ?? "",
          onChanged: (address) => _onAddressChanged(address: address),
          focusNode: _addressFocus,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _addressFocus.unfocus(),
          validator: (_) => !state.isAddressValid && state.address.isNotEmpty
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
          initialValue: widget._ownerAccount?.address.addressSecondary ?? "",
          onChanged: (addressSecondary) => _onAddressSecondaryChanged(addressSecondary: addressSecondary),
          focusNode: _addressSecondaryFocus,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _addressSecondaryFocus.unfocus(),
          validator: (_) => !state.isAddressSecondaryValid && state.addressSecondary.isNotEmpty
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
          initialValue: widget._ownerAccount?.address.city ?? "",
          onChanged: (city) => _onCityChanged(city: city),
          focusNode: _cityFocus,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _cityFocus.unfocus(),
          validator: (_) => !state.isCityValid && state.city.isNotEmpty
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
          initialValue: _stateFormatter.getMaskedText(),
          onChanged: (_) => _onStateChanged(),
          focusNode: _stateFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _stateFocus.unfocus(),
          validator: (_) => !state.isStateValid && state.state.isNotEmpty
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
          initialValue: _zipFormatter.getMaskedText(),
          onChanged: (_) => _onZipChanged(),
          focusNode: _zipFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _zipFocus.unfocus(),
          validator: (_) => !state.isZipValid && state.zip.isNotEmpty
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
    return state.isFormValid && !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _fieldsChanged({required OwnerFormState state}) {
    if (widget._ownerAccount == null) return true;
    OwnerAccount ownerAccount = widget._ownerAccount!;
    
    return ownerAccount.primary != state.isPrimary ||
      ownerAccount.firstName != state.firstName ||
      ownerAccount.lastName != state.lastName ||
      ownerAccount.title != state.title ||
      ownerAccount.phone != state.phone ||
      ownerAccount.email != state.email ||
      ownerAccount.percentOwnership.toString() != state.percentOwnership ||
      ownerAccount.dob != state.dob ||
      ownerAccount.ssn != state.ssn ||
      ownerAccount.address.address != state.address ||
      (ownerAccount.address.addressSecondary ?? "") != state.addressSecondary ||
      ownerAccount.address.city != state.city ||
      ownerAccount.address.state.toUpperCase() != state.state.toUpperCase() ||
      ownerAccount.address.zip != state.zip;
  }

  void _submitButtonPressed({required OwnerFormState state, required BuildContext context}) {
    if (_buttonEnabled(state: state)) {
      if (widget._ownerAccount != null) {
        BlocProvider.of<OwnerFormBloc>(context).add(Updated());
      } else {
        BlocProvider.of<OwnerFormBloc>(context).add(Submitted());
      }
    }
  }

  void _onFirstNameChanged({required String firstName}) {
    _ownerFormBloc.add(FirstNameChanged(firstName: firstName));
  }

  void _onLastNameChanged({required String lastName}) {
    _ownerFormBloc.add(LastNameChanged(lastName: lastName));
  }

  void _onTitleChanged({required String title}) {
    _ownerFormBloc.add(TitleChanged(title: title));
  }

  void _onPhoneChanged() {
    _ownerFormBloc.add(PhoneChanged(phone: _phoneFormatter.getUnmaskedText()));
  }

  void _onEmailChanged({required String email}) {
    _ownerFormBloc.add(EmailChanged(email: email));
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
    if (_percentOwnershipFormatter.getMaskedText().isNotEmpty) {
      _ownerFormBloc.add(PercentOwnershipChanged(percentOwnership: int.parse(_percentOwnershipFormatter.getMaskedText())));
    }
  }

  void _onSsnChanged() {
    _ownerFormBloc.add(SsnChanged(ssn: _ssnFormatter.getUnmaskedText()));
  }

  void _onAddressChanged({required String address}) {
    _ownerFormBloc.add(AddressChanged(address: address));
  }

  void _onAddressSecondaryChanged({required String addressSecondary}) {
    _ownerFormBloc.add(AddressSecondaryChanged(addressSecondary: addressSecondary));
  }

  void _onCityChanged({required String city}) {
    _ownerFormBloc.add(CityChanged(city: city));
  }

  void _onStateChanged() {
    _ownerFormBloc.add(StateChanged(state: _stateFormatter.getMaskedText()));
  }

  void _onZipChanged() {
    _ownerFormBloc.add(ZipChanged(zip: _zipFormatter.getMaskedText()));
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
      initialDate: state.isDobValid &&  state.dob != "" ? DateFormat.yMd().parse(state.dob) : DateTime.now(),
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
        _ownerFormBloc.add(DobChanged(dob: _dobController.text));
      }
    });
  }

  void _cancelButtonPressed() {
    BlocProvider.of<OwnersScreenBloc>(context).add(HideForm());
  }
}