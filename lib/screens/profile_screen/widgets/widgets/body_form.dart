import 'package:dashboard/blocs/business/business_bloc.dart';
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
  final Profile? _profile;

  const BodyForm({Profile? profile, Key? key})
    : _profile = profile,
      super(key: key);

  @override
  State<BodyForm> createState() => _BodyFormState();
}

class _BodyFormState extends State<BodyForm> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();
  late MaskTextInputFormatter _phoneFormatter;

  @override
  void initState() {
    super.initState();
    _phoneFormatter = InputFormatters.phone(initial: _setProfile().phone);
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
    _nameFocus.dispose();
    _websiteFocus.dispose();
    _descriptionFocus.dispose();
    _phoneFocus.dispose();

    super.dispose();
  }

  Widget _nameField({required ProfileScreenState state}) {
    return TextFormField(
      key: const Key("nameFieldKey"),
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
      onChanged: (name) => _onNameChanged(name: name),
      initialValue: _setProfile().name,
      focusNode: _nameFocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      validator: (_) => !state.isNameValid && state.name.isNotEmpty
        ? 'Invalid Business Name'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  
  Widget _websiteTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: const Key("websiteFieldKey"),
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
      onChanged: (website) => _onWebsiteChanged(website: website),
      initialValue: _scrubWebsite(website: _setProfile().website),
      focusNode: _websiteFocus,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isWebsiteValid && state.website.isNotEmpty
        ? 'Invalid Website url'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
    );
  }

  Widget _phoneTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: const Key("phoneTextFieldKey"),
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
      onChanged: (_) => _onPhoneChanged(),
      initialValue: _phoneFormatter.getMaskedText(),
      focusNode: _phoneFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isPhoneValid && state.phone.isNotEmpty
        ? 'Invalid Phone Number'
        : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      inputFormatters: [_phoneFormatter],
    );
  }

  Widget _descriptionTextField({required ProfileScreenState state}) {
    return TextFormField(
      key: const Key("descriptionTextKey"),
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
      onChanged: (description) => _onDescriptionChanged(description: description),
      initialValue: _setProfile().description,
      focusNode: _descriptionFocus,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _nameFocus.unfocus(),
      validator: (_) => !state.isDescriptionValid && state.description.isNotEmpty
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
        key: const Key("submitButtonKey"),
        onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
        child: _buttonChild(state: state),
      )
    );
  }

  Profile _setProfile() {
    return widget._profile ?? BlocProvider.of<BusinessBloc>(context).business.profile;
  }

  void _submitButtonPressed({required ProfileScreenState state}) {
    if (_buttonEnabled(state: state)) {
      BlocProvider.of<BusinessBloc>(context).business.profile.identifier.isEmpty
        ? BlocProvider.of<ProfileScreenBloc>(context).add(Submitted())
        : BlocProvider.of<ProfileScreenBloc>(context).add(Updated());
    }
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<ProfileScreenBloc>(context).add(Reset()));
  }

  bool _buttonEnabled({required ProfileScreenState state}) {
    return state.isFormValid && !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _fieldsChanged({required ProfileScreenState state}) {
    Profile profile = BlocProvider.of<BusinessBloc>(context).business.profile;
    
    if (profile.identifier.isEmpty) return true;
    return profile.name != state.name ||
      profile.website != state.website ||
      profile.phone != _phoneFormatter.getUnmaskedText() ||
      profile.description != state.description;
  }

  Widget _buttonChild({required ProfileScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
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

  void _onNameChanged({required String name}) {
    BlocProvider.of<ProfileScreenBloc>(context).add(NameChanged(name: name));
  }

  void _onWebsiteChanged({required String website}) {
    BlocProvider.of<ProfileScreenBloc>(context).add(WebsiteChanged(website: website));
  }

  void _onPhoneChanged() {
    BlocProvider.of<ProfileScreenBloc>(context).add(PhoneChanged(phone: _phoneFormatter.getUnmaskedText()));
  }

  void _onDescriptionChanged({required String description}) {
    BlocProvider.of<ProfileScreenBloc>(context).add(DescriptionChanged(description: description));
  }
}