import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/locked_form/bloc/locked_form_bloc.dart';
import 'widgets/locked_form/locked_form.dart';
import 'widgets/unlocked_form/cubit/unlocked_form_cubit.dart';
import 'widgets/unlocked_form/unlocked_form.dart';

class SettingsScreenBody extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider());
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: BlocBuilder<SettingsScreenCubit, bool>(
        builder: (context, isLocked) {
          if (isLocked) {
            return _lockedForm(context: context);
          }
          return _unlockedForm();
        }
      )
    );
  }

  Widget _lockedForm({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.getWidth(20),
        right: SizeConfig.getWidth(20),
      ),
      child: BlocProvider<LockedFormBloc>(
        create: (context) => LockedFormBloc(
          authenticationRepository: _authenticationRepository,
          settingsScreenCubit: context.read<SettingsScreenCubit>()
        ),
        child: LockedForm(),
      ),
    );
  }

  Widget _unlockedForm() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.getWidth(5),
        right: SizeConfig.getWidth(5),
      ),
      child: BlocProvider<UnlockedFormCubit>(
        create: (_) => UnlockedFormCubit(),
        child: UnlockedForm(),
      ),
    );
  }
  
  // final FocusNode _unlockPasswordFocus = FocusNode();
  // final FocusNode _emailFocus = FocusNode();
  // final FocusNode _passwordFocus = FocusNode();
  // final FocusNode _passwordConfirmationFocus = FocusNode();

  // final TextEditingController _unlockPasswordController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _passwordConfirmationController = TextEditingController();

  // TextEditingController _emailController;

  // SettingsScreenBloc _settingsScreenBloc;
  
  // @override
  // void initState() {
  //   super.initState();
  //   _settingsScreenBloc = BlocProvider.of<SettingsScreenBloc>(context);
  //   _emailController = TextEditingController(text: BlocProvider.of<BusinessBloc>(context).business.email);
    
  //   _unlockPasswordController.addListener(_onUnlockPasswordChanged);
  //   _emailController.addListener(_onEmailChanged);
  //   _passwordController.addListener(_onPasswordChanged);
  //   _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  // }
  
  // @override
  // Widget build(BuildContext context) {
  //   return BlocListener<SettingsScreenBloc, SettingsScreenState>(
  //     listener: (context, state) {
  //       if (state.isSuccess) {
  //         _showSuccess(context: context);
  //       }
  //     },
  //     child: Padding(
  //         padding: EdgeInsets.only(
  //           left: SizeConfig.getWidth(25),
  //           right: SizeConfig.getWidth(25)
  //         ),
  //         child: Form(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               _title(),
  //               _errorMessage(),
  //               SizedBox(height: SizeConfig.getHeight(5)),
  //               _body(),
  //             ],
  //           )
  //         ),
  //       )
  //   );
  // }

  // @override
  // void dispose() {
  //   _unlockPasswordController.dispose();
  //   _passwordController.dispose();
  //   _passwordConfirmationController.dispose();
  //   _emailController.dispose();
  //   super.dispose();
  // }

  // Widget _title() {
  //   return Center(
  //     child: BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //       builder: (context, state) {
  //         return Column(
  //           children: [
  //             BoldText3(
  //               text:  state.isLocked 
  //                 ? "Account Settings"
  //                 : state.isEditingEmail
  //                   ? "Update Email"
  //                   : "Change Password",
  //               context: context
  //             ),
  //             state.isLocked
  //               ? Text5(text: "Current password required to update email or password", context: context)
  //               : Container()
  //           ],
  //         );
  //       }
  //     ),
  //   );
  // }

  // Widget _body() {
  //   return BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //     builder: (context, state) {
  //       if (state.isLocked) {
  //         return _unlockPasswordForm();
  //       }
        
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           state.isEditingEmail
  //             ? _emailField(state: state)
  //             : _passwordForm(state: state),
  //           SizedBox(height: SizeConfig.getHeight(4)),
  //           _buttons()
  //         ],
  //       );
  //     }
  //   );
  // }

  // Widget _unlockPasswordForm() {
  //   return BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //     builder: (context, state) {
  //       return state.isLocked
  //         ? Column(
  //             children: [
  //               _unlockPasswordField(state: state),
  //               SizedBox(height: SizeConfig.getHeight(3)),
  //               Row(
  //                 children: [
  //                   SizedBox(width: SizeConfig.getWidth(5)),
  //                   Expanded(child: _unlockButton(state: state)),
  //                   SizedBox(width: SizeConfig.getWidth(5)),
  //                 ],
  //               ) ,
  //               SizedBox(height: SizeConfig.getHeight(3)),
  //             ],
  //           )
  //         : Container();
  //     }
  //   );
  // }

  // Widget _unlockPasswordField({@required SettingsScreenState state}) {
  //   return TextFormField(
  //     enabled: state.isLocked,
  //     textCapitalization: TextCapitalization.none,
  //     decoration: InputDecoration(
  //       labelText: "Current Password",
  //       labelStyle: TextStyle(
  //         fontWeight: FontWeight.w400,
  //         fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //       ),
  //     ),
  //     style: TextStyle(
  //       fontWeight: FontWeight.w700,
  //       fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //     ),
  //     controller: _unlockPasswordController,
  //     focusNode: _unlockPasswordFocus,
  //     keyboardType: TextInputType.visiblePassword,
  //     textInputAction: TextInputAction.done,
  //     autocorrect: false,
  //     onFieldSubmitted: (_) {
  //       _unlockPasswordFocus.unfocus();
  //       _submitUnlockPassword(state: state);
  //     },
  //     validator: (_) => !state.isUnlockPasswordValid && _unlockPasswordController.text.isNotEmpty
  //       ? "Invalid Password"
  //       : null,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     obscureText: true,
  //     enableSuggestions: false,
  //   );
  // }

  // Widget _unlockButton({@required SettingsScreenState state}) {
  //   return Shaker(
  //     control: state.errorButtonControl,
  //     onAnimationComplete: _resetForm,
  //     child: ElevatedButton(
  //       onPressed: _unlockButtonEnabled(state: state)
  //         ? () => _submitUnlockPassword(state: state)
  //         : null,
  //       child: _unlockButtonChild(state: state)
  //     )
  //   );
  // }

  // Widget _unlockButtonChild({@required SettingsScreenState state}) {
  //   return state.isSubmitting
  //     ? Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
  //     : Text4(text: "Unlock", context: context, color: Theme.of(context).colorScheme.onSecondary);
  // }

  // Widget _passwordForm({@required SettingsScreenState state}) {
  //   return Column(
  //     children: [
  //       _passwordField(state: state),
  //       SizedBox(height: SizeConfig.getHeight(3)),
  //       _passwordConfirmationField(state: state)
  //     ],
  //   );
  // }

  // Widget _emailField({@required SettingsScreenState state}) {
  //   return TextFormField(
  //     enabled: !state.isLocked,
  //     textCapitalization: TextCapitalization.none,
  //     decoration: InputDecoration(
  //       labelText: "New Email",
  //       labelStyle: TextStyle(
  //         fontWeight: FontWeight.w400,
  //         fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //       ),
  //     ),
  //     style: TextStyle(
  //       fontWeight: FontWeight.w700,
  //       fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //     ),
  //     controller: _emailController,
  //     focusNode: _emailFocus,
  //     keyboardType: TextInputType.emailAddress,
  //     textInputAction: TextInputAction.done,
  //     autocorrect: false,
  //     onFieldSubmitted: (_) {
  //       _emailFocus.unfocus();
  //       _submitEmail(state: state);
  //     },
  //     validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty
  //       ? "Invalid Email"
  //       : null,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     enableSuggestions: false,
  //   );
  // }

  // Widget _passwordField({@required SettingsScreenState state}) {
  //   return TextFormField(
  //     enabled: !state.isLocked,
  //     textCapitalization: TextCapitalization.none,
  //     decoration: InputDecoration(
  //       labelText: "New Password",
  //       labelStyle: TextStyle(
  //         fontWeight: FontWeight.w400,
  //         fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //       ),
  //     ),
  //     style: TextStyle(
  //       fontWeight: FontWeight.w700,
  //       fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //     ),
  //     controller: _passwordController,
  //     focusNode: _passwordFocus,
  //     keyboardType: TextInputType.visiblePassword,
  //     textInputAction: TextInputAction.done,
  //     autocorrect: false,
  //     onFieldSubmitted: (_) {
  //       _passwordFocus.unfocus();
  //       _submitPassword(state: state);
  //     },
  //     validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty
  //       ? "Invalid Password"
  //       : null,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     obscureText: true,
  //     enableSuggestions: false,
  //   );
  // }

  // Widget _passwordConfirmationField({@required SettingsScreenState state}) {
  //   return TextFormField(
  //     enabled: !state.isLocked,
  //     textCapitalization: TextCapitalization.none,
  //     decoration: InputDecoration(
  //       labelText: "Confirm Password",
  //       labelStyle: TextStyle(
  //         fontWeight: FontWeight.w400,
  //         fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //       ),
  //     ),
  //     style: TextStyle(
  //       fontWeight: FontWeight.w700,
  //       fontSize: FontSizeAdapter.setSize(size: 3, context: context)
  //     ),
  //     controller: _passwordConfirmationController,
  //     focusNode: _passwordConfirmationFocus,
  //     keyboardType: TextInputType.visiblePassword,
  //     textInputAction: TextInputAction.done,
  //     autocorrect: false,
  //     onFieldSubmitted: (_) {
  //       _passwordConfirmationFocus.unfocus();
  //       _submitPassword(state: state);
  //     },
  //     validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty
  //       ? "Confirmation does not match"
  //       : null,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     obscureText: true,
  //     enableSuggestions: false,
  //   );
  // }

  // Widget _errorMessage() {
  //   return BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //     builder: (context, state) {
  //       if (state.errorMessage.length > 0) {
  //         return Column(
  //           children: [
  //             SizedBox(height: SizeConfig.getHeight(2)),
  //             TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
  //           ],
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }

  // Widget _buttons() {
  //   return Row(
  //     children: [
  //       Expanded(child: _toggleButton()),
  //       SizedBox(width: SizeConfig.getWidth(5)),
  //       Expanded(child: _submitButton())
  //     ],
  //   );
  // }

  // Widget _submitButton() {
  //   return BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //     builder: (context, state) {
  //       return Shaker(
  //         control: state.errorButtonControl,
  //         onAnimationComplete: _resetForm,
  //         child: ElevatedButton(
  //           onPressed: _submitButtonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
  //           child: _submitButtonChild(state: state),
  //         )
  //       );
  //     },
  //   );
  // }

  // Widget _submitButtonChild({@required SettingsScreenState state}) {
  //   return state.isSubmitting && !state.isLocked
  //     ? Padding(padding: EdgeInsets.only(top: 5, bottom: 5), child: CircularProgressIndicator())
  //     : Text4(
  //         text: state.isEditingEmail ? "Update Email" : "Change Password", 
  //         context: context, 
  //         color: Theme.of(context).colorScheme.onSecondary
  //       ); 
  // }
  
  // Widget _toggleButton() {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.info)
  //     ),
  //     onPressed: () => _settingsScreenBloc.add(ToggleButtonPressed()), 
  //     child: _toggleButtonChild()
  //   );
  // }

  // Widget _toggleButtonChild() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 5, bottom: 5), 
  //     child: BlocBuilder<SettingsScreenBloc, SettingsScreenState>(
  //       builder: (context, state) {
  //         return Text4(
  //           text: state.isEditingEmail ? "Change Password" : "Update Email", 
  //           context: context, 
  //           color: Theme.of(context).colorScheme.onSecondary
  //         );
  //       }
  //     ) 
  //   );
  // }

  // bool _submitButtonEnabled({@required SettingsScreenState state}) {
  //   if (state.isEditingEmail) {
  //     return state.isEmailValid && 
  //       _emailController.text.isNotEmpty && 
  //       !state.isSubmitting && 
  //       widget._business.email != _emailController.text;
  //   }
  //   return state.isPasswordValid && 
  //     _passwordController.text.isNotEmpty &&
  //     state.isPasswordConfirmationValid &&
  //     _passwordConfirmationController.text.isNotEmpty &&
  //     !state.isSubmitting;
  // }

  // bool _unlockButtonEnabled({@required SettingsScreenState state}) {
  //   return state.isUnlockPasswordValid &&
  //     _unlockPasswordController.text.isNotEmpty &&
  //     !state.isSubmitting;
  // }

  // void _submitUnlockPassword({@required SettingsScreenState state}) {
  //   if (_unlockButtonEnabled(state: state)) {
  //     _settingsScreenBloc.add(SubmittedUnlockPassword(unlockPassword: _unlockPasswordController.text));
  //   }
  // }

  // void _submitButtonPressed({@required SettingsScreenState state}) {
  //   if (_submitButtonEnabled(state: state)) {
  //     state.isEditingEmail
  //       ? _submitEmail(state: state)
  //       : _submitPassword(state: state);
  //   }
  // }
  
  // void _submitEmail({@required SettingsScreenState state}) {
  //   _settingsScreenBloc.add(SubmittedEmail(email: _emailController.text));
  // }

  // void _submitPassword({@required SettingsScreenState state}) {
  //   _settingsScreenBloc.add(SubmittedPassword(
  //     password: _passwordController.text,
  //     passwordConfirmation: _passwordConfirmationController.text
  //   ));
  // }
  
  // void _onUnlockPasswordChanged() {
  //   _settingsScreenBloc.add(UnlockPasswordChanged(unlockPassword: _unlockPasswordController.text));
  // }

  // void _onEmailChanged() {
  //   _settingsScreenBloc.add(EmailChanged(email: _emailController.text));
  // }

  // void _onPasswordChanged() {
  //   _settingsScreenBloc.add(PasswordChanged(
  //     password: _passwordController.text,
  //     passwordConfirmation: _passwordConfirmationController.text
  //   ));
  // }

  // void _onPasswordConfirmationChanged() {
  //   _settingsScreenBloc.add(PasswordConfirmationChanged(
  //     password: _passwordController.text,
  //     passwordConfirmation: _passwordConfirmationController.text
  //   ));
  // }

  // void _resetForm() {
  //   Future.delayed(Duration(seconds: 1), () => _settingsScreenBloc.add(Reset()));
  // }

  // void _showSuccess({@required BuildContext context}) {    
  //   ToastMessage(
  //     context: context,
  //     message: widget._business.email != BlocProvider.of<BusinessBloc>(context).business.email
  //       ? "Email Updated"
  //       : "Password Updated",
  //     color: Theme.of(context).colorScheme.success
  //   ).showToast().then((_) => Navigator.of(context).pop());
  // }
}