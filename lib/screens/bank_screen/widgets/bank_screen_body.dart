import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/input_formatters.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/bank_screen/bloc/bank_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BankScreenBody extends StatefulWidget {

  const BankScreenBody({Key? key})
    : super(key: key);
  
  @override
  State<BankScreenBody> createState() => _BankScreenBodyState();
}

class _BankScreenBodyState extends State<BankScreenBody> {
  late final BankAccount _bankAccount;
  
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _routingNumberFocus = FocusNode();
  final FocusNode _accountNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _addressSecondaryFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _zipFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();

  late MaskTextInputFormatter _routingNumberFormatter;
  late MaskTextInputFormatter _accountNumberFormatter;
  late MaskTextInputFormatter _zipFormatter;
  late MaskTextInputFormatter _stateFormatter;

  late BankScreenBloc _bankScreenBloc;
  
  @override
  void initState() {
    super.initState();
    _bankScreenBloc = BlocProvider.of<BankScreenBloc>(context);
    _bankAccount = BlocProvider.of<BusinessBloc>(context).business.accounts.bankAccount;

    _routingNumberFormatter = InputFormatters.routingNumber(initial: _bankAccount.routingNumber);
    _accountNumberFormatter = InputFormatters.accountNumber(initial: _bankAccount.accountNumber);
    _zipFormatter = InputFormatters.setLengthDigits(numberDigits: 5, initial: _bankAccount.address.zip);
    _stateFormatter = InputFormatters.setLengthAlpha(numberAlpha: 2, initial: _bankAccount.address.state);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<BankScreenBloc, BankScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess(context: context);
        }
      },
      child: SingleChildScrollView(
        key: const Key("scrollKey"),
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.getWidth(10),
            right: SizeConfig.getWidth(10)
          ),
          child: Form(
            child: BlocBuilder<BankScreenBloc, BankScreenState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _title(state: state),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    _formBody(state: state)
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _routingNumberFocus.dispose();
    _accountNumberFocus.dispose();
    _addressFocus.dispose();
    _addressSecondaryFocus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
    _zipFocus.dispose();

    _bankScreenBloc.close();

    super.dispose();
  }

  Widget _title({required BankScreenState state}) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(3)),
          BoldText3(text: 'Banking Details', context: context),
          state.accountType == AccountType.unknown
            ? Text5(text: 'Please select your Bank Account type.', context: context)
            : Text5(text: "Great! Now just a few details about your Account.", context: context)
        ],
      ),
    );
  }

  Widget _formBody({required BankScreenState state}) {
    if (state.accountType == AccountType.unknown) {
      return _accountTypeBody();
    }
    return _bankAccountDataBody(state: state);
  }

  Widget _accountTypeBody() {
    return Row(
      children: [
        SizedBox(width: SizeConfig.getWidth(5)),
        Expanded(
          child: Column(
            key: const Key("accountTypeKey"),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _accountTypeButton(buttonText: 'Checking Account', accountType: AccountType.checking),
              SizedBox(height: SizeConfig.getHeight(10)),
              _accountTypeButton(buttonText: 'Savings Account', accountType: AccountType.saving)
            ],
          ),
        ),
        SizedBox(width: SizeConfig.getWidth(5)),
      ],
    );
  }

  Widget _accountTypeButton({required String buttonText, required AccountType accountType}) {
    return ElevatedButton(
      key: Key(accountType.toString()),
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(top: SizeConfig.getWidth(3), bottom: SizeConfig.getWidth(3)))),
      child: Text4(text: buttonText, context: context, color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () => _bankScreenBloc.add(AccountTypeSelected(accountType: accountType)),
    );
  }

  Widget _bankAccountDataBody({required BankScreenState state}) {
    return Column(
      key: const Key("AccountDataKey"),
      children: [
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
              rowFit: FlexFit.tight,
              child: _firstNameTextField(state: state),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _lastNameTextField(state: state),
            )
          ],
        ),
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
              rowFit: FlexFit.tight,
              child: _routingNumberTextField(state: state),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _accountNumberTextField(state: state),
            )
          ],
        ),
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
              rowFit: FlexFit.tight,
              child: _addressTextField(state: state),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _addressSecondaryTextField(state: state),
            )
          ],
        ),
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
              rowFit: FlexFit.tight,
              child: _cityTextField(state: state)
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _stateTextField(state: state)
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _zipTextField(state: state)
            )
          ],
        ),
        _errorMessage(state: state),
        SizedBox(height: SizeConfig.getHeight(4)),
        Row(
          children: [
            Expanded(child: _changeAccountTypeButton()),
            SizedBox(width: SizeConfig.getWidth(5)),
            Expanded(child: _submitButton(state: state)),
          ],
        )
      ],
    );
  }

  Widget _firstNameTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("firstNameKey"),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Account holder first name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      initialValue: _bankAccount.firstName,
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

  Widget _lastNameTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("lastNameKey"),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Account holder last name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      initialValue: _bankAccount.lastName,
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

  Widget _routingNumberTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("routingKey"),
      decoration: InputDecoration(
        labelText: 'Routing Number',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      initialValue: _routingNumberFormatter.getMaskedText(),
      onChanged: (_) => _onRoutingNumberChanged(),
      focusNode: _routingNumberFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _routingNumberFocus.unfocus(),
      validator: (_) => !state.isRoutingNumberValid && state.routingNumber.isNotEmpty
        ? 'Invalid Routing Number'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      inputFormatters: [_routingNumberFormatter],
    );
  }

  Widget _accountNumberTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("accountKey"),
      decoration: InputDecoration(
        labelText: 'Account Number',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      initialValue: _accountNumberFormatter.getMaskedText(),
      onChanged: (_) => _onAccountNumberChanged(),
      focusNode: _accountNumberFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _accountNumberFocus.unfocus(),
      validator: (_) => !state.isAccountNumberValid && state.accountNumber.isNotEmpty
        ? 'Invalid Account Number'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      inputFormatters: [_accountNumberFormatter],
    );
  }

  Widget _addressTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("addressKey"),
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
      initialValue: _bankAccount.address.address,
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

  Widget _addressSecondaryTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("addressSecondaryKey"),
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
      initialValue: _bankAccount.address.addressSecondary,
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
  }

  Widget _cityTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("cityKey"),
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
      initialValue: _bankAccount.address.city,
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
  }

  Widget _stateTextField({required BankScreenState state}) {    
    return TextFormField(
      key: const Key("stateKey"),
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
  }

  Widget _zipTextField({required BankScreenState state}) {
    return TextFormField(
      key: const Key("zipKey"),
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
  }

  Widget _errorMessage({required BankScreenState state}) {
    if (!state.isFailure) return Container();

    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(2)),
        TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
      ],
    );
  }

  Widget _submitButton({required BankScreenState state}) {
    return Shaker(
      control: state.errorButtonControl,
      onAnimationComplete: _resetForm,
      child: ElevatedButton(
        key: const Key("submitButtonKey"),
        onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
        child: _buttonChild(state: state), 
      )
    );
  }

  Widget _buttonChild({required BankScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    ); 
  }

  Widget _changeAccountTypeButton() {
    return ElevatedButton(
      key: const Key("changeAccountTypeKey"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.warning)
      ),
      onPressed: () => _bankScreenBloc.add(ChangeAccountTypeSelected()), 
      child: _changeAccountButtonChild()
    );
  }

  Widget _changeAccountButtonChild() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: Text4(text: 'Change Account Type', context: context, color: Theme.of(context).colorScheme.onSecondary)
    ); 
  }

  bool _buttonEnabled({required BankScreenState state}) {
    return state.isFormValid && !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _fieldsChanged({required BankScreenState state}) {
    if (_bankAccount.identifier.isEmpty) return true;
    
    return _bankAccount.accountType != state.accountType ||
      _bankAccount.firstName != state.firstName ||
      _bankAccount.lastName != state.lastName ||
      _bankAccount.routingNumber != _routingNumberFormatter.getMaskedText() ||
      _bankAccount.accountNumber != _accountNumberFormatter.getMaskedText() ||
      _bankAccount.address.address != state.address ||
      _bankAccount.address.addressSecondary != state.addressSecondary ||
      _bankAccount.address.city != state.city ||
      _bankAccount.address.state != _stateFormatter.getMaskedText() ||
      _bankAccount.address.zip != _zipFormatter.getMaskedText();
  }

  void _onFirstNameChanged({required String firstName}) {
    _bankScreenBloc.add(FirstNameChanged(firstName: firstName));
  }

  void _onLastNameChanged({required String lastName}) {
    _bankScreenBloc.add(LastNameChanged(lastName: lastName));
  }

  void _onRoutingNumberChanged() {
    _bankScreenBloc.add(RoutingNumberChanged(routingNumber: _routingNumberFormatter.getMaskedText()));
  }

  void _onAccountNumberChanged() {
    _bankScreenBloc.add(AccountNumberChanged(accountNumber: _accountNumberFormatter.getMaskedText()));
  }

  void _onAddressChanged({required String address}) {
    _bankScreenBloc.add(AddressChanged(address: address));
  }

  void _onAddressSecondaryChanged({required String addressSecondary}) {
    _bankScreenBloc.add(AddressSecondaryChanged(addressSecondary: addressSecondary));
  }

  void _onCityChanged({required String city}) {
    _bankScreenBloc.add(CityChanged(city: city));
  }

  void _onStateChanged() {
    _bankScreenBloc.add(StateChanged(state: _stateFormatter.getMaskedText()));
  }

  void _onZipChanged() {
    _bankScreenBloc.add(ZipChanged(zip: _zipFormatter.getMaskedText()));
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _bankScreenBloc.add(Reset()));
  }

  void _submitButtonPressed({required BankScreenState state}) {
    if (_buttonEnabled(state: state)) {
      _bankAccount.identifier.isEmpty
        ? _bankScreenBloc.add(Submitted())
        : _bankScreenBloc.add(Updated());
    }
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Banking Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop(true));
  }
}