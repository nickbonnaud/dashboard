import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/input_formatters.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/business_account_screen/bloc/business_account_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BusinessAccountScreenBody extends StatefulWidget {
  
  const BusinessAccountScreenBody({Key? key})
    : super(key: key);
  
  @override
  State<BusinessAccountScreenBody> createState() => _BusinessAccountScreenBodyState();
}

class _BusinessAccountScreenBodyState extends State<BusinessAccountScreenBody> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _addressSecondaryFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _zipFocus = FocusNode();
  final FocusNode _einFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();

  late MaskTextInputFormatter _zipFormatter;
  late MaskTextInputFormatter _einFormatter;
  late MaskTextInputFormatter _stateFormatter;


  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _addressSecondaryController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _einController;
  
  late BusinessAccountScreenBloc _accountFormBloc;
  
  @override
  void initState() {
    super.initState();
    _accountFormBloc = BlocProvider.of<BusinessAccountScreenBloc>(context);
    
    _zipFormatter = InputFormatters.setLengthDigits(numberDigits: 5, initial: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.zip);
    _einFormatter = InputFormatters.ein(initial: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.ein ?? "");
    _stateFormatter = InputFormatters.setLengthAlpha(numberAlpha: 2, initial: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.state);
    
    _nameController = TextEditingController(text: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.businessName);
    _addressController = TextEditingController(text: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.address);
    _addressSecondaryController = TextEditingController(text: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.addressSecondary);
    _cityController = TextEditingController(text: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.city);
    _zipController = TextEditingController(text: _zipFormatter.getMaskedText());
    _einController = TextEditingController(text: _einFormatter.getMaskedText());
    _stateController = TextEditingController(text: _stateFormatter.getMaskedText());

    _nameController.addListener(_onNameChanged);
    _addressController.addListener(_onAddressChanged);
    _addressSecondaryController.addListener(_onAddressSecondaryChanged);
    _cityController.addListener(_onCityChanged);
    _stateController.addListener(_onStateChanged);
    _zipController.addListener(_onZipChanged);
    _einController.addListener(_onEinChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<BusinessAccountScreenBloc, BusinessAccountScreenState>(
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
            key: const Key("formKey"),
            child: BlocBuilder<BusinessAccountScreenBloc, BusinessAccountScreenState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _title(state: state),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    _formBody(state: state)
                  ],
                );
              },
            )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();

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

    _einController.dispose();
    _einFocus.dispose();

    _accountFormBloc.close();

    super.dispose();
  }

  Widget _title({required BusinessAccountScreenState state}) {
    return Center(
      child: Column(
        children: [
          BoldText3(text: 'Business Details', context: context),
          state.entityType == EntityType.unknown
            ? Text5(text: "Please select your Business Entity type.", context: context)
            : Text5(text: "Great! Next let's get some details.", context: context)
        ],
      ),
    );
  }

  Widget _formBody({required BusinessAccountScreenState state}) {
    if (state.entityType == EntityType.unknown) {
      return _entityTypeBody();
    }
    return _businessDataBody(state: state);
  }

  Widget _businessDataBody({required BusinessAccountScreenState state}) {
    return Column(
      key: const Key("businessDataBody"),
      children: [
        _nameTextField(state: state),
        SizedBox(height: SizeConfig.getHeight(3)),
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
              child: _addressTextField(state: state)
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: _addressSecondaryTextField(state: state)
            )
          ],
        ),
        SizedBox(height: SizeConfig.getHeight(3)),
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
        _einTextField(state: state),
        _errorMessage(state: state),
        SizedBox(height: SizeConfig.getHeight(4)),
        Row(
          children: [
            Expanded(child: _changeEntityButton()),
            SizedBox(width: SizeConfig.getWidth(5)),
            Expanded(child: _submitButton(state: state)),
          ],
        )
      ],
    );
  }

  Widget _changeEntityButton() {
    return ElevatedButton(
      key: const Key("changeEntityKey"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.warning)
      ),
      onPressed: () => _accountFormBloc.add(ChangeEntityTypeSelected()), 
      child: _changeEntityButtonChild()
    );
  }
  
  Widget _changeEntityButtonChild() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: Text4(text: 'Change Entity Type', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }
  
  Widget _submitButton({required BusinessAccountScreenState state}) {
    return Shaker(
      control: state.errorButtonControl,
      onAnimationComplete: _resetForm,
      child: ElevatedButton(
        key: const Key("submitButtonKey"),
        onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
        child: _submitButtonChild(state: state),
      )
    );
  }

  Widget _submitButtonChild({required BusinessAccountScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }
  
  Widget _errorMessage({required BusinessAccountScreenState state}) {
    if (!state.isFailure) return Container();

    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(2)),
        TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
      ],
    );
  }
  
  Widget _einTextField({required BusinessAccountScreenState state}) {
    if (state.entityType == EntityType.soleProprietorship) return Container();

    return TextFormField(
      key: const Key("einKey"),
      decoration: InputDecoration(
        labelText: 'EIN',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _einController,
      focusNode: _einFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _einFocus.unfocus(),
      validator: (_) => !state.isEinValid && _einController.text.isNotEmpty
        ? 'Invalid EIN'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      inputFormatters: [_einFormatter],
    );
  }
  
  Widget _zipTextField({required BusinessAccountScreenState state}) {
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

  Widget _stateTextField({required BusinessAccountScreenState state}) {    
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
  
  Widget _cityTextField({required BusinessAccountScreenState state}) {
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
  
  Widget _addressSecondaryTextField({required BusinessAccountScreenState state}) {
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
  
  Widget _addressTextField({required BusinessAccountScreenState state}) {
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

  Widget _nameTextField({required BusinessAccountScreenState state}) {
    return TextFormField(
      key: const Key("nameKey"),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Business Name on Taxes',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _nameController,
      focusNode: _nameFocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isNameValid && _nameController.text.isNotEmpty
        ? 'Invalid Business Name'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
    );
  }

  Widget _entityTypeBody() {
    return Row(
      children: [
        SizedBox(width: SizeConfig.getWidth(5)),
        Expanded(
          child: Column(
            key: const Key("entityTypeBody"),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _entityTypeButton(buttonText: 'Sole Proprietorship', entityType: EntityType.soleProprietorship),
              SizedBox(height: SizeConfig.getHeight(5)),
              _entityTypeButton(buttonText: 'PartnerShip', entityType: EntityType.partnership),
              SizedBox(height: SizeConfig.getHeight(5)),
              _entityTypeButton(buttonText: 'LLC', entityType: EntityType.llc),
              SizedBox(height: SizeConfig.getHeight(5)),
              _entityTypeButton(buttonText: 'Corporation', entityType: EntityType.corporation)
            ],
          ),
        ),
        SizedBox(width: SizeConfig.getWidth(5)),
      ],
    );
  }
  
  Widget _entityTypeButton({required String buttonText, required EntityType entityType}) {
    return ElevatedButton(
      key: Key(entityType.toString()),
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(top: SizeConfig.getWidth(3), bottom: SizeConfig.getWidth(3)))),
      child: Text4(text: buttonText, context: context, color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () => _accountFormBloc.add(EntityTypeSelected(entityType: entityType)),
    );
  }

  bool _buttonEnabled({required BusinessAccountScreenState state}) {
    return state.isFormValid && _isFormPopulated(state: state) && !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _isFormPopulated({required BusinessAccountScreenState state}) {
    return _nameController.text.isNotEmpty &&
      _addressController.text.isNotEmpty &&
      _cityController.text.isNotEmpty &&
      _stateController.text.isNotEmpty &&
      _zipController.text.isNotEmpty &&
      (_einController.text.isNotEmpty || state.entityType == EntityType.unknown);
  }
  
  void _onStateChanged() {
    _accountFormBloc.add(StateChanged(state: _stateController.text));
  }
  
  void _onNameChanged() {
    _accountFormBloc.add(NameChanged(name: _nameController.text));
  }

  void _onAddressChanged() {
    _accountFormBloc.add(AddressChanged(address: _addressController.text));
  }

  void _onAddressSecondaryChanged() {
    _accountFormBloc.add(AddressSecondaryChanged(addressSecondary: _addressSecondaryController.text));
  }

  void _onCityChanged() {
    _accountFormBloc.add(CityChanged(city: _cityController.text));
  }

  void _onZipChanged() {
    _accountFormBloc.add(ZipChanged(zip: _zipFormatter.getUnmaskedText()));
  }

  void _onEinChanged() {
    _accountFormBloc.add(EinChanged(ein: _einFormatter.getMaskedText()));
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _accountFormBloc.add(Reset()));
  }

  void _submitButtonPressed({required BusinessAccountScreenState state}) {
    if (_buttonEnabled(state: state)) {
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.identifier.isEmpty
        ? _accountFormBloc.add(Submitted(
            entityType: state.entityType,
            name: _nameController.text,
            address: _addressController.text,
            addressSecondary: _addressSecondaryController.text,
            city: _cityController.text,
            state: _stateFormatter.getMaskedText(),
            zip: _zipFormatter.getMaskedText(),
            ein: _einFormatter.getMaskedText()
          ))
        : _accountFormBloc.add(Updated(
            entityType: state.entityType,
            name: _nameController.text,
            address: _addressController.text,
            addressSecondary: _addressSecondaryController.text,
            city: _cityController.text,
            state: _stateFormatter.getMaskedText(),
            zip: _zipFormatter.getMaskedText(),
            ein: _einFormatter.getMaskedText(),
            id: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.identifier
          ));
    }
  }

  bool _fieldsChanged({required BusinessAccountScreenState state}) {
    if (BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.identifier.isEmpty) return true;
    
    return BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.entityType != state.entityType ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.businessName != _nameController.text ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.address != _addressController.text ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.addressSecondary != _addressSecondaryController.text ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.city != _cityController.text ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.state != _stateFormatter.getMaskedText() ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.address.zip != _zipFormatter.getMaskedText() ||
      BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount.ein != _einFormatter.getMaskedText();
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Details Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}