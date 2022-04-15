import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'bloc/email_form_bloc.dart';

class EmailForm extends StatefulWidget {

  const EmailForm({Key? key})
    : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final FocusNode _focusNode = FocusNode();

  late EmailFormBloc _emailFormBloc;
  
  @override
  void initState() {
    super.initState();
    _emailFormBloc = BlocProvider.of<EmailFormBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailFormBloc, EmailFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoldText4(text: "Change Email", context: context),
          SizedBox(height: SizeConfig.getHeight(5)),
          _emailField(),
          SizedBox(height: SizeConfig.getHeight(4)),
          _errorMessage(),
          _submitButton()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _emailFormBloc.close();
    super.dispose();
  }

  Widget _emailField() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("emailTextFieldKey"),
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: "New Email",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          initialValue: BlocProvider.of<BusinessBloc>(context).business.email,
          onChanged: (email) => _onEmailChanged(email: email),
          focusNode: _focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) {
            _focusNode.unfocus();
            _submitEmail(state: state);
          },
          validator: (_) => !state.isEmailValid && state.email.isNotEmpty
            ? "Invalid Email"
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enableSuggestions: false,
        );
      }
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
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
          child: BlocBuilder<EmailFormBloc, EmailFormState>(
            builder: (context, state) {
              return Shaker(
                control: state.errorButtonControl,
                onAnimationComplete: () => _resetForm(),
                child: ElevatedButton(
                  key: const Key("emailSubmitButtonKey"),
                  onPressed: _emailValid(state: state)
                    ? () => _submitEmail(state: state)
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

  Widget _buttonChild({required EmailFormState state}) {
    return state.isSubmitting
      ? const Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
      : Text4(text: "Change", context: context, color: Theme.of(context).colorScheme.onSecondary);
  }

  bool _emailValid({required EmailFormState state}) {
    return state.isEmailValid &&
      state.email.isNotEmpty && 
      BlocProvider.of<BusinessBloc>(context).business.email != state.email &&
      !state.isSubmitting;
  }
  
  void _onEmailChanged({required String email}) {
    _emailFormBloc.add(EmailChanged(email: email));
  }
  
  void _submitEmail({required EmailFormState state}) {
    if (_emailValid(state: state)) {
      _emailFormBloc.add(Submitted());
    }
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _emailFormBloc.add(Reset()));
  }

  void _showSuccess() {
    ToastMessage(
      context: context,
      message: "Email Updated!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}