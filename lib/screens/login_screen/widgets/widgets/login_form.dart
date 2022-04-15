import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/screens/request_reset_password_screen/request_reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'bloc/login_form_bloc.dart';

class LoginForm extends StatefulWidget {

  const LoginForm({Key? key})
    : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  late LoginFormBloc _loginFormBloc;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    _loginFormBloc = BlocProvider.of<LoginFormBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pushReplacementNamed(Routes.app);
        }
      },
      child: Form(
        child: SingleChildScrollView(
          key:const  Key("scrollKey"),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getHeight(6)),
              Center(
                child: BoldText5(
                  text: "Login", 
                  context: context
                )
              ),
              SizedBox(height: SizeConfig.getHeight(5)),
              _emailTextField(),
              SizedBox(height: SizeConfig.getHeight(1)),
              _passwordTextField(),
              _errorMessage(),
              SizedBox(height: SizeConfig.getHeight(5)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.getWidth(1)),
                  Expanded(child: _submitButton()),
                  SizedBox(width: SizeConfig.getWidth(1)),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(5)),
              _goToRegisterButton(),
              SizedBox(height: SizeConfig.getHeight(3)),
              _resetPasswordButton()
            ],
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();

    _passwordController.dispose();
    _passwordFocus.dispose();

    _loginFormBloc.close();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
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
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _changeFocus(
            context: context, 
            current: _emailFocus, 
            next: _passwordFocus
          ),
          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty ? 'Invalid email' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
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
          controller: _passwordController,
          focusNode: _passwordFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
          },
          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Invalid Password' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          obscureText: true,
        );
      },
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
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

  Widget _submitButton() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
            child: _submitButtonChild(state: state)
          )
        );
      },
    );
  }

  Widget _goToRegisterButton() {
    return Center(
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
          return TextButton(
            key: const Key("goToRegisterButtonKey"),
            child: Text(
              "Don't have an account?",
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
              : () => Navigator.of(context).pushNamed('/register')
          );
        },
      )
    );
  }

  Widget _resetPasswordButton() {
    return Center(
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
          return TextButton(
            key: const Key("resetPasswordButtonKey"),
            child: Text(
              "Forgot your Password?",
              style: TextStyle(
                color: state.isSubmitting
                  ? Theme.of(context).colorScheme.warningDisabled
                  : Theme.of(context).colorScheme.warning,
                decoration: TextDecoration.underline,
                fontSize: FontSizeAdapter.setSize(size: 2, context: context)
              ),
            ),
            onPressed: state.isSubmitting
              ? null
              : () => _goToResetScreen(),
          );
        },
      ),
    );
  }

  Widget _submitButtonChild({required LoginFormState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Login', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  bool _buttonEnabled({required LoginFormState state}) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _goToResetScreen() {
    Navigator.of(context).push(MaterialPageRoute<RequestResetPasswordScreen>(
      fullscreenDialog: true,
      builder: (_) => const RequestResetPasswordScreen(
        authenticationRepository: AuthenticationRepository(authenticationProvider: AuthenticationProvider(), tokenRepository: TokenRepository()),
      )
    ));
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _loginFormBloc.add(Reset()));
  }

  void _onEmailChanged() {
    _loginFormBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginFormBloc.add(PasswordChanged(password: _passwordController.text));
  }
  
  void _submitButtonPressed({required LoginFormState state}) {
    if (_buttonEnabled(state: state)) {
      _loginFormBloc.add(Submitted(email: _emailController.text, password: _passwordController.text));
    }
  }

  void _changeFocus({required BuildContext context, required FocusNode current, required FocusNode next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
}