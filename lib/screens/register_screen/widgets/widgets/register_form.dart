import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/register_form_bloc.dart';

class RegisterForm extends StatefulWidget {
  
  const RegisterForm({Key? key})
    : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();
  
  late RegisterFormBloc _registerFormBloc;
  
  @override
  void initState() {
    super.initState();
    _registerFormBloc = BlocProvider.of<RegisterFormBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterFormBloc, RegisterFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pushReplacementNamed(Routes.app);
        }
      },
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getHeight(6)),
              Center(
                child: BoldText5(
                  text: "Register",
                  context: context,
                ),
              ),
              SizedBox(height: SizeConfig.getHeight(5)),
              _emailTextField(),
              SizedBox(height: SizeConfig.getHeight(1)),
              _passwordTextField(),
              SizedBox(height: SizeConfig.getHeight(1)),
              _passwordConfirmationTextField(),
              _errorMessage(),
              SizedBox(height: SizeConfig.getHeight(3)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.getWidth(1)),
                  Expanded(child: _submitButton()),
                  SizedBox(width: SizeConfig.getWidth(1)),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(5)),
              _goToLoginButton()
            ],
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();

    _registerFormBloc.close();

    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("emailTextFieldKey"),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          onChanged: (email) => _onEmailChanged(email: email),
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _changeFocus(
            context: context, 
            current: _emailFocus, 
            next: _passwordFocus
          ),
          validator: (_) => !state.isEmailValid && state.email.isNotEmpty 
            ? 'Invalid email' 
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordTextFieldKey"),
          decoration: InputDecoration(
            labelText: 'Password',
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          onFieldSubmitted: (_) {
            _changeFocus(context: context, current: _passwordFocus, next: _passwordConfirmationFocus);
          },
          validator: (_) => !state.isPasswordValid && state.password.isNotEmpty 
            ? 'min: 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character' 
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          obscureText: true,
        );
      },
    );
  }

  Widget _passwordConfirmationTextField() {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordConfirmationTextFieldKey"),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
          onFieldSubmitted: (_) {
            _passwordConfirmationFocus.unfocus();
          },
          validator: (_) => !state.isPasswordConfirmationValid  && state.passwordConfirmation.isNotEmpty 
            ? "Passwords are not matching" 
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          obscureText: true,
        );
      },
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        if (state.errorMessage.isEmpty) return Container();
        return Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
          ],
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
            child: _buttonChild(state: state),
          )
        );
      },
    );
  }

  Widget _goToLoginButton() {
    return Center(
      child: BlocBuilder<RegisterFormBloc, RegisterFormState>(
        builder: (context, state) {
          return TextButton(
            key: const Key("goToLoginButtonKey"),
            child: Text(
              "Already have an account?",
              style: TextStyle(
                color: state.isSubmitting
                  ? Theme.of(context).colorScheme.callToActionDisabled
                  : Theme.of(context).colorScheme.callToAction,
                decoration: TextDecoration.underline,
                fontSize: FontSizeAdapter.setSize(size: 2.5, context: context)
              ),
            ),
            onPressed: state.isSubmitting
              ? null
              : () => Navigator.of(context).pop()
          );
        },
      ),
    );
  }

  Widget _buttonChild({required RegisterFormState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Register', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  bool _buttonEnabled({required RegisterFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () {
      _registerFormBloc.add(Reset());
    });
  }

  void _submitButtonPressed({required RegisterFormState state}) {
    if (_buttonEnabled(state: state)) {
      _registerFormBloc.add(Submitted());
    }
  }
  
  void _changeFocus({required BuildContext context, required FocusNode current, required FocusNode next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
  
  void _onEmailChanged({required String email}) {
    _registerFormBloc.add(EmailChanged(email: email));
  }

  void _onPasswordChanged({required String password}) {
    _registerFormBloc.add(PasswordChanged(password: password));
  }

  void _onPasswordConfirmationChanged({required String passwordConfirmation}) {
    _registerFormBloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
  }
}