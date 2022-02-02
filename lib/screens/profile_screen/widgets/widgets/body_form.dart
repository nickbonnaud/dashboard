import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/input_formatters.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BodyForm extends StatefulWidget {
  final Profile _profile;
  final ProfileScreenBloc _profileScreenBloc;

  BodyForm({required Profile profile, required ProfileScreenBloc profileScreenBloc})
    : _profile = profile,
      _profileScreenBloc = profileScreenBloc;

  @override
  State<BodyForm> createState() => _BodyFormState();
}

class _BodyFormState extends State<BodyForm> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = ResponsiveLayoutHelper();

  late TextEditingController _nameController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;

  late MaskTextInputFormatter _phoneFormatter;
  
  bool get _isPopulated => 
    _nameController.text.isNotEmpty &&
    _websiteController.text.isNotEmpty &&
    _descriptionController.text.isNotEmpty &&
    _phoneController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget._profile.name);
    _websiteController = TextEditingController(text: _scrubWebsite(website: widget._profile.website));
    _descriptionController = TextEditingController(text: widget._profile.description);
    
    _phoneFormatter = InputFormatters.phone(initial: widget._profile.phone);
    _phoneController = TextEditingController(text: _phoneFormatter.getMaskedText());
    
    _nameController.addListener(_onNameChanged);
    _websiteController.addListener(_onWebsiteChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
          builder: (context, state) =>  _nameField(state: state)
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
              rowFit:FlexFit.tight,
              child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                builder: (context, state) {
                  return _websiteTextField(state: state);
                },
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit:FlexFit.tight,
              child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
                builder: (context, state) {
                  return _phoneTextField(state: state);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.getHeight(3)),
        BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
          builder: (context, state) => _descriptionTextField(state: state)
        ),
        BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
          builder: (context, state) => _errorMessage(state: state)
        ),
        SizedBox(height: SizeConfig.getHeight(4)),
        Row(
          children: [
            SizedBox(width: SizeConfig.getWidth(10)),
            Expanded(child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
              builder: (context, state) => _submitButton(state: state),
            )),
            SizedBox(width: SizeConfig.getWidth(10)),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();

    _websiteController.dispose();
    _websiteFocus.dispose();

    _descriptionController.dispose();
    _descriptionFocus.dispose();

    _phoneController.dispose();
    _phoneFocus.dispose();

    super.dispose();
  }

  Widget _nameField({required ProfileScreenState state}) {
    return TextFormField(
      key: Key("nameFieldKey"),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Official Name (as appears on taxes)',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _nameController,
      focusNode: _nameFocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      validator: (_) => !state.isNameValid && _nameController.text.isNotEmpty
        ? 'Invalid Business Name'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  
  Widget _websiteTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: Key("websiteFieldKey"),
      decoration: InputDecoration(
        prefixText: 'www.',
        prefixStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context),
          color: Theme.of(context).colorScheme.onPrimary
        ),
        labelText: 'Website',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _websiteController,
      focusNode: _websiteFocus,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isWebsiteValid && _websiteController.text.isNotEmpty
        ? 'Invalid Website url'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
    );
  }

  Widget _phoneTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: Key("phoneTextFieldKey"),
      decoration: InputDecoration(
        labelText: 'Phone',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context) 
      ),
      controller: _phoneController,
      focusNode: _phoneFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isPhoneValid && _phoneController.text.isNotEmpty
        ? 'Invalid Phone Number'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      inputFormatters: [_phoneFormatter],
    );
  }

  Widget _descriptionTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: Key("descriptionTextKey"),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context) 
      ),
      controller: _descriptionController,
      focusNode: _descriptionFocus,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isDescriptionValid && _descriptionController.text.isNotEmpty
        ? 'Description must be longer'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _errorMessage({required ProfileScreenState state}) {
    if (state.errorMessage.isEmpty) return Container();

    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(2)),
        TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
      ],
    );
  }

  Widget _submitButton({required ProfileScreenState state}) {
    return Shaker(
      control: state.errorButtonControl,
      onAnimationComplete: () => _resetForm(),
      child: ElevatedButton(
        key: Key("submitButtonKey"),
        onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
        child: _buttonChild(state: state),
      )
    );
  }

  void _submitButtonPressed({required ProfileScreenState state}) {
    if (_buttonEnabled(state: state)) {
      widget._profile.identifier.isEmpty
        ? widget._profileScreenBloc.add(Submitted(
            name: _nameController.text,
            website: _websiteController.text,
            description: _descriptionController.text,
            phone: _phoneController.text,
          ))
        : widget._profileScreenBloc.add(Updated(
            name: _nameController.text,
            website: _websiteController.text,
            description: _descriptionController.text,
            phone: _phoneController.text,
            id: widget._profile.identifier
          ));
    }
  }

  void _resetForm() {
    Future.delayed(Duration(seconds: 1), () => widget._profileScreenBloc.add(Reset()));
  }

  bool _buttonEnabled({required ProfileScreenState state}) {
    _nameController.text.isNotEmpty &&
    _websiteController.text.isNotEmpty &&
    _descriptionController.text.isNotEmpty &&
    _phoneController.text.isNotEmpty;
    return state.isFormValid && _isPopulated && !state.isSubmitting && _fieldsChanged();
  }

  bool _fieldsChanged() {
    if (widget._profile.identifier.isEmpty) return true;
    return widget._profile.name != _nameController.text ||
      widget._profile.website != "www.${_websiteController.text}" ||
      widget._profile.phone != _phoneFormatter.getUnmaskedText() ||
      widget._profile.description != _descriptionController.text;
  }

  Widget _buttonChild({required ProfileScreenState state}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction)
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  String _scrubWebsite({required String website}) {
    return website.contains('www.')
      ? website.replaceAll('www.', '')
      : website;
  }

  void _onNameChanged() {
    widget._profileScreenBloc.add(NameChanged(name: _nameController.text));
  }

  void _onWebsiteChanged() {
    widget._profileScreenBloc.add(WebsiteChanged(website: _websiteController.text));
  }

  void _onDescriptionChanged() {
    widget._profileScreenBloc.add(DescriptionChanged(description: _descriptionController.text));
  }

  void _onPhoneChanged() {
    widget._profileScreenBloc.add(PhoneChanged(phone: _phoneFormatter.getUnmaskedText()));
  }
}