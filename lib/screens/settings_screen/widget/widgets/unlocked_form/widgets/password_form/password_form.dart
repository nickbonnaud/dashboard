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

  const PasswordForm({Key? key})
    : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();

  late PasswordFormBloc _passwordFormBloc;

  @override
  void initState() {
    super.initState();
    _passwordFormBloc = BlocProvider.of<PasswordFormBloc>(context);
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
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();

    _passwordFormBloc.close();

    super.dispose();
  }

  Widget _passwordField() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordTextFieldKey"),
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
          onChanged: (password) => _onPasswordChanged(password: password),
          focusNode: _passwordFocus,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
            _submitPassword(state: state);
          },
          validator: (_) => !state.isPasswordValid && state.password.isNotEmpty
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
          key: const Key("passwordConfirmationTextFieldKey"),
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
          onChanged: (passwordConfirmation) => _onPasswordConfirmationChanged(passwordConfirmation: passwordConfirmation),
          focusNode: _passwordConfirmationFocus,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) {
            _passwordConfirmationFocus.unfocus();
            _submitPassword(state: state);
          },
          validator: (_) => !state.isPasswordConfirmationValid && state.passwordConfirmation.isNotEmpty
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
                  key: const Key("submitPasswordButtonKey"),
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
      ? const Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
      : Text4(text: "Change", context: context, color: Theme.of(context).colorScheme.onSecondary);
  }

  bool _formValid({required PasswordFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }
  
  void _onPasswordChanged({required String password}) {
    _passwordFormBloc.add(PasswordChanged(password: password));
  }

  void _onPasswordConfirmationChanged({required String passwordConfirmation}) {
    _passwordFormBloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
  }

  void _submitPassword({required PasswordFormState state}) {
    if (_formValid(state: state)) {
      _passwordFormBloc.add(Submitted(identifier: BlocProvider.of<BusinessBloc>(context).business.identifier));
    }
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _passwordFormBloc.add(Reset()));
  }

  void _showSuccess() {
    ToastMessage(
      context: context,
      message: "Password Changed!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}