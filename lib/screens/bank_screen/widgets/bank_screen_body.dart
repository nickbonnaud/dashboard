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

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _routingNumberController;
  late TextEditingController _accountNumberController;
  late TextEditingController _addressController;
  late TextEditingController _addressSecondaryController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  late BankScreenBloc _bankScreenBloc;
  
  bool get _isPopulated =>
    _firstNameController.text.isNotEmpty &&
    _lastNameController.text.isNotEmpty &&
    _routingNumberController.text.isNotEmpty &&
    _accountNumberController.text.isNotEmpty &&
    _addressController.text.isNotEmpty &&
    _cityController.text.isNotEmpty &&
    _stateController.text.isNotEmpty &&
    _zipController.text.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    _bankScreenBloc = BlocProvider.of<BankScreenBloc>(context);
    _bankAccount = BlocProvider.of<BusinessBloc>(context).business.accounts.bankAccount;

    _routingNumberFormatter = InputFormatters.routingNumber(initial: _bankAccount.routingNumber);
    _accountNumberFormatter = InputFormatters.accountNumber(initial: _bankAccount.accountNumber);
    _zipFormatter = InputFormatters.setLengthDigits(numberDigits: 5, initial: _bankAccount.address.zip);
    _stateFormatter = InputFormatters.setLengthAlpha(numberAlpha: 2, initial: _bankAccount.address.state);

    _firstNameController = TextEditingController(text: _bankAccount.firstName);
    _lastNameController = TextEditingController(text: _bankAccount.lastName);
    _routingNumberController = TextEditingController(text: _routingNumberFormatter.getMaskedText());
    _accountNumberController = TextEditingController(text: _accountNumberFormatter.getMaskedText());
    _addressController = TextEditingController(text: _bankAccount.address.address);
    _addressSecondaryController = TextEditingController(text: _bankAccount.address.addressSecondary);
    _cityController = TextEditingController(text: _bankAccount.address.city);
    _stateController = TextEditingController(text: _stateFormatter.getMaskedText());
    _zipController = TextEditingController(text: _zipFormatter.getMaskedText());

    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _routingNumberController.addListener(_onRoutingNumberChanged);
    _accountNumberController.addListener(_onAccountNumberChanged);
    _addressController.addListener(_onAddressChanged);
    _addressSecondaryController.addListener(_onAddressSecondaryChanged);
    _cityController.addListener(_onCityChanged);
    _stateController.addListener(_onStateChanged);
    _zipController.addListener(_onZipChanged);
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
    _firstNameController.dispose();
    _firstNameFocus.dispose();

    _lastNameController.dispose();
    _lastNameFocus.dispose();

    _routingNumberController.dispose();
    _routingNumberFocus.dispose();

    _accountNumberController.dispose();
    _accountNumberFocus.dispose();

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
      controller: _routingNumberController,
      focusNode: _routingNumberFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _routingNumberFocus.unfocus(),
      validator: (_) => !state.isRoutingNumberValid && _routingNumberController.text.isNotEmpty
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
      controller: _accountNumberController,
      focusNode: _accountNumberFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _accountNumberFocus.unfocus(),
      validator: (_) => !state.isAccountNumberValid && _accountNumberController.text.isNotEmpty
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
    return state.isFormValid && _isPopulated && !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _fieldsChanged({required BankScreenState state}) {
    if (_bankAccount.identifier.isEmpty) return true;
    
    return _bankAccount.accountType != state.accountType ||
      _bankAccount.firstName != _firstNameController.text ||
      _bankAccount.lastName != _lastNameController.text ||
      _bankAccount.routingNumber != _routingNumberFormatter.getMaskedText() ||
      _bankAccount.accountNumber != _accountNumberFormatter.getMaskedText() ||
      _bankAccount.address.address != _addressController.text ||
      _bankAccount.address.addressSecondary != _addressSecondaryController.text ||
      _bankAccount.address.city != _cityController.text ||
      _bankAccount.address.state != _stateFormatter.getMaskedText() ||
      _bankAccount.address.zip != _zipFormatter.getMaskedText();
  }

  void _onFirstNameChanged() {
    _bankScreenBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _bankScreenBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  void _onRoutingNumberChanged() {
    _bankScreenBloc.add(RoutingNumberChanged(routingNumber: _routingNumberController.text));
  }

  void _onAccountNumberChanged() {
    _bankScreenBloc.add(AccountNumberChanged(accountNumber: _accountNumberController.text));
  }

  void _onAddressChanged() {
    _bankScreenBloc.add(AddressChanged(address: _addressController.text));
  }

  void _onAddressSecondaryChanged() {
    _bankScreenBloc.add(AddressSecondaryChanged(addressSecondary: _addressSecondaryController.text));
  }

  void _onCityChanged() {
    _bankScreenBloc.add(CityChanged(city: _cityController.text));
  }

  void _onStateChanged() {
    _bankScreenBloc.add(StateChanged(state: _stateController.text));
  }

  void _onZipChanged() {
    _bankScreenBloc.add(ZipChanged(zip: _zipFormatter.getUnmaskedText()));
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _bankScreenBloc.add(Reset()));
  }

  void _submitButtonPressed({required BankScreenState state}) {
    if (_buttonEnabled(state: state)) {
      _bankAccount.identifier.isEmpty
        ? _bankScreenBloc.add(Submitted(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            routingNumber: _routingNumberController.text,
            accountNumber: _accountNumberController.text,
            accountType: state.accountType,
            address: _addressController.text,
            addressSecondary: _addressSecondaryController.text,
            city: _cityController.text,
            state: _stateController.text,
            zip: _zipController.text,
          ))
        : _bankScreenBloc.add(Updated(
            identifier: _bankAccount.identifier,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            routingNumber: _routingNumberController.text,
            accountNumber: _accountNumberController.text,
            accountType: state.accountType,
            address: _addressController.text,
            addressSecondary: _addressSecondaryController.text,
            city: _cityController.text,
            state: _stateController.text,
            zip: _zipController.text,
          ));
    }
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Banking Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}