import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../bloc/reset_password_screen_bloc.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  final String? _token;

  const ResetPasswordScreenBody({required String? token, Key? key})
    : _token = token,
      super(key: key);
  
  @override
  State<ResetPasswordScreenBody> createState() => _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<ResetPasswordScreenBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();

  late ResetPasswordScreenBloc _resetPasswordScreenBloc;

  bool get isPopulated => _passwordController.text.isNotEmpty && _passwordConfirmationController.text.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    _resetPasswordScreenBloc = BlocProvider.of<ResetPasswordScreenBloc>(context);

    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess();
        }
      },
      child: widget._token == null
        ? _noTokenPresent()
        : _passwordResetForm()
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();

    _passwordConfirmationController.dispose();
    _passwordConfirmationFocus.dispose();

    _resetPasswordScreenBloc.close();

    super.dispose();
  }

  Widget _noTokenPresent() {
    return Center(
      child: Text4(
        text: "Reset Password Token is Invalid.",
        context: context,
        color: Theme.of(context).colorScheme.danger,
      ),
    );
  }

  Widget _passwordResetForm() {
    return Form(
      key: const Key("passwordResetFormKey"),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(6)),
            BoldText5(text: "Reset Password", context: context),
            SizedBox(height: SizeConfig.getHeight(8)),
            _passwordTextField(),
            SizedBox(height: SizeConfig.getHeight(3)),
            _passwordConfirmationTextField(),
            _errorMessage(),
            SizedBox(height: SizeConfig.getHeight(10)),
            Row(
              children: [
                SizedBox(width: SizeConfig.getWidth(1)),
                Expanded(
                  child: _submitButton(),
                ),
                SizedBox(width: SizeConfig.getWidth(1)),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<ResetPasswordScreenBloc, ResetPasswordScreenState>(
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
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
          },
          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty 
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
    return BlocBuilder<ResetPasswordScreenBloc, ResetPasswordScreenState>(
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
          controller: _passwordConfirmationController,
          focusNode: _passwordConfirmationFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
          onFieldSubmitted: (_) {
            _passwordConfirmationFocus.unfocus();
          },
          validator: (_) => !state.isPasswordConfirmationValid  && _passwordConfirmationController.text.isNotEmpty 
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
    return BlocBuilder<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          return Column(
            children: [
              SizedBox(height: SizeConfig.getHeight(3)),
              TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
            ],
          );
        }
        return Container();
      }
    );
  }
  
  Widget _submitButton() {
    return BlocBuilder<ResetPasswordScreenBloc, ResetPasswordScreenState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () =>  _resetForm(),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
            child: _buttonChild(state: state),
          )
        );
      },
    );
  }

  Widget _buttonChild({required ResetPasswordScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Change', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }
  
  bool _buttonEnabled({required ResetPasswordScreenState state}) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }
  
  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _resetPasswordScreenBloc.add(Reset()));
  }

  void _submitButtonPressed({required ResetPasswordScreenState state}) {
    if (_buttonEnabled(state: state)) {
      _resetPasswordScreenBloc.add(Submitted(
        password: _passwordController.text, 
        passwordConfirmation: _passwordConfirmationController.text
      ));
    }
  }

  void _onPasswordChanged() {
    _resetPasswordScreenBloc.add(PasswordChanged(
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text
    ));
  }

  void _onPasswordConfirmationChanged() {
    _resetPasswordScreenBloc.add(PasswordConfirmationChanged(
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text
    ));
  }

  void _showSuccess() {
    ToastMessage(
      context: context,
      message: "Password Successfully Changed!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pushReplacementNamed(Routes.login));
  }
}