import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'bloc/locked_form_bloc.dart';

class LockedForm extends StatefulWidget {

  const LockedForm({Key? key})
    : super(key: key);

  @override
  State<LockedForm> createState() => _LockedFormState();
}

class _LockedFormState extends State<LockedForm> {
  final FocusNode _focusNode = FocusNode();
  
  late LockedFormBloc _lockedFormBloc;
  
  @override
  void initState() {
    super.initState();
    _lockedFormBloc = BlocProvider.of<LockedFormBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoldText4(text: 'Account Settings', context: context),
          Text5(text: "Current password required to update email or password", context: context),
          SizedBox(height: SizeConfig.getHeight(5)),
          _unlockPasswordField(),
          SizedBox(height: SizeConfig.getHeight(4)),
          _errorMessage(),
          _unlockButton()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _lockedFormBloc.close();
    super.dispose();
  }

  Widget _unlockPasswordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(10)),
      child: BlocBuilder<LockedFormBloc, LockedFormState>(
        builder: (context, state) {
          return TextFormField(
            key: const Key("unlockPasswordTextFieldKey"),
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: "Current Password",
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
            focusNode: _focusNode,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            onFieldSubmitted: (_) {
              _focusNode.unfocus();
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
      ),
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<LockedFormBloc, LockedFormState>(
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

  Widget _unlockButton() {
    return Row(
      children: [
        SizedBox(width: SizeConfig.getWidth(15)),
        Expanded(
          child: BlocBuilder<LockedFormBloc, LockedFormState>(
            builder: (context, state) {
              return Shaker(
                control: state.errorButtonControl,
                onAnimationComplete: () => _resetForm(),
                child: ElevatedButton(
                  key: const Key("unlockButtonKey"),
                  onPressed: _passwordValid(state: state)
                    ? () => _submitPassword(state: state)
                    : null,
                  child: _buttonChild(state: state)
                )
              );
            },
          )
        ),
        SizedBox(width: SizeConfig.getWidth(15)),
      ],
    );
  }

  Widget _buttonChild({required LockedFormState state}) {
    return state.isSubmitting
      ? const Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
      : Text4(text: "Unlock", context: context, color: Theme.of(context).colorScheme.onSecondary);
  }

  bool _passwordValid({required LockedFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }
  
  void _onPasswordChanged({required String password}) {
    _lockedFormBloc.add(PasswordChanged(password: password));
  }

  void _submitPassword({required LockedFormState state}) {
    if (_passwordValid(state: state)) {
      _lockedFormBloc.add(Submitted());
    }
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => _lockedFormBloc.add(Reset()));
  }
}