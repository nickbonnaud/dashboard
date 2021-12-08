import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'bloc/password_form_bloc.dart';

class PasswordForm extends StatefulWidget {
  final BusinessBloc _businessBloc;

  const PasswordForm({required BusinessBloc businessBloc})
    : _businessBloc = businessBloc;

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  late PasswordFormBloc _passwordFormBloc;

  @override
  void initState() {
    super.initState();
    _passwordFormBloc = BlocProvider.of<PasswordFormBloc>(context);

    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordFormBloc, PasswordFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoldText4(text: "Change Password", context: context),
          SizedBox(height: SizeConfig.getHeight(5)),
          _passwordField(),
          SizedBox(height: SizeConfig.getHeight(2)),
          _passwordConfirmationField(),
          SizedBox(height: SizeConfig.getHeight(4)),
          _errorMessage(),
          _submitButton()
        ],
      ),
    ) ;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();

    _passwordConfirmationController.dispose();
    _passwordConfirmationFocus.dispose();

    _passwordFormBloc.close();

    super.dispose();
  }

  Widget _passwordField() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("passwordTextFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: "New Password",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _passwordController,
          focusNode: _passwordFocus,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
            _submitPassword(state: state);
          },
          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty
            ? "Invalid Password"
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          enableSuggestions: false,
        );
      }
    );
  }

  Widget _passwordConfirmationField() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("passwordConfirmationTextFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _passwordConfirmationController,
          focusNode: _passwordConfirmationFocus,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) {
            _passwordConfirmationFocus.unfocus();
            _submitPassword(state: state);
          },
          validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty
            ? "Confirmation does not match"
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          enableSuggestions: false,
        );
      }
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          return Column(
            children: [
              TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger),
              SizedBox(height: SizeConfig.getHeight(2)),
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget _submitButton() {
    return Row(
      children: [
        SizedBox(width: SizeConfig.getWidth(10)),
        Expanded(
          child: BlocBuilder<PasswordFormBloc, PasswordFormState>(
            builder: (context, state) {
              return Shaker(
                control: state.errorButtonControl,
                onAnimationComplete: () => _resetForm(),
                child: ElevatedButton(
                  key: Key("submitPasswordButtonKey"),
                  onPressed: _formValid(state: state)
                    ? () => _submitPassword(state: state)
                    : null,
                  child: _buttonChild(state: state)
                )
              );
            },
          )
        ),
        SizedBox(width: SizeConfig.getWidth(10)),
      ],
    );
  }

  Widget _buttonChild({required PasswordFormState state}) {
    return state.isSubmitting
      ? Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
      : Text4(text: "Change", context: context, color: Theme.of(context).colorScheme.onSecondary);
  }

  bool _formValid({required PasswordFormState state}) {
    final bool passwordValid = state.isPasswordValid && _passwordController.text.isNotEmpty;
    final bool passwordConfirmationValid = state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty;
    return passwordValid && passwordConfirmationValid && !state.isSubmitting;
  }
  
  void _onPasswordChanged() {
    _passwordFormBloc.add(PasswordChanged(
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text
    ));
  }

  void _onPasswordConfirmationChanged() {
    _passwordFormBloc.add(PasswordConfirmationChanged(
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text
    ));
  }

  void _submitPassword({required PasswordFormState state}) {
    if (_formValid(state: state)) {
      _passwordFormBloc.add(Submitted(
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        identifier: widget._businessBloc.business.identifier
      ));
    }
  }

  void _resetForm() {
    Future.delayed(Duration(seconds: 1), () => _passwordFormBloc.add(Reset()));
  }

  void _showSuccess() {
    ToastMessage(
      context: context,
      message: "Password Changed!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}