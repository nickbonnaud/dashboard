import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../bloc/request_reset_password_screen_bloc.dart';

class RequestResetPasswordScreenBody extends StatefulWidget {

  @override
  State<RequestResetPasswordScreenBody> createState() => _RequestResetPasswordScreenBodyState();
}

class _RequestResetPasswordScreenBodyState extends State<RequestResetPasswordScreenBody> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  late RequestResetPasswordScreenBloc _resetPasswordScreenBloc;
  
  @override
  void initState() {
    super.initState();
    _resetPasswordScreenBloc = BlocProvider.of<RequestResetPasswordScreenBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess();
        }
      },
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getHeight(6)),
              BoldText5(text: "Request Password Reset", context: context),
              SizedBox(height: SizeConfig.getHeight(10)),
              _emailTextField(),
              _errorMessage(),
              SizedBox(height: SizeConfig.getHeight(15)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.getWidth(1)),
                  Expanded(
                    child: _submitButton(),
                  ),
                  SizedBox(width: SizeConfig.getWidth(1)),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(5)),
              _goToLoginButton()
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("emailTextFieldKey"),
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
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _emailFocus.unfocus();
            _submitButtonPressed(state: state);
          },
          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty
            ? 'Invalid Email'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
        );
      }
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) return Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(3), context: context, color: Theme.of(context).colorScheme.danger)
          ],
        );

        return Container();
      },
    );
  }
  
  Widget _submitButton() {
    return BlocBuilder<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(),
          child: ElevatedButton(
            key: Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state)
              ? () => _submitButtonPressed(state: state)
              : null,
            child: _submitButtonChild(state: state)
          )
        );
      }
    );
  }

  Widget _submitButtonChild({required RequestResetPasswordScreenState state}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? CircularProgressIndicator()
        : Text4(text: 'Request Reset', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  Widget _goToLoginButton() {
    return BlocBuilder<RequestResetPasswordScreenBloc, RequestResetPasswordScreenState>(
      builder: (context, state) {
        return TextButton(
          key: Key("goToLoginButtonKey"),
          child: Text(
            "Go to Login",
            style: TextStyle(
              color: state.isSubmitting
                ? Theme.of(context).colorScheme.warningDisabled
                : Theme.of(context).colorScheme.warning,
              decoration: TextDecoration.underline,
              fontSize: FontSizeAdapter.setSize(size: 2.5, context: context)
            ),
          ),
          onPressed: state.isSubmitting
            ? null
            : () => Navigator.of(context).pop(),
        );
      }
    );
  }
  
  bool _buttonEnabled({required RequestResetPasswordScreenState state}) {
    return state.isEmailValid && !state.isSubmitting && _emailController.text.isNotEmpty;
  }

  void _submitButtonPressed({required RequestResetPasswordScreenState state}) {
    if (_buttonEnabled(state: state)) {
      _resetPasswordScreenBloc.add(Submitted(email: _emailController.text));
    }
  }
  
  void _onEmailChanged() {
    _resetPasswordScreenBloc.add(EmailChanged(email: _emailController.text));
  }

  void _resetForm() {
    Future.delayed(Duration(seconds: 1), () {
      _resetPasswordScreenBloc.add(Reset());
    });
  }

  void _showSuccess() {
    ToastMessage(
      context: context,
      message: "Reset Password Email Sent.",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}