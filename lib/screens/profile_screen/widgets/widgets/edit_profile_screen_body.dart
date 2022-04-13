import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'body_form.dart';


class EditProfileScreenBody extends StatelessWidget {

  const EditProfileScreenBody({ Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileScreenBloc, ProfileScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess(context: context);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.getWidth(10),
            right: SizeConfig.getWidth(10)
          ),
          child: Form(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.getHeight(10)),
                BoldText3(text: "Profile", context: context),
                SizedBox(height: SizeConfig.getHeight(5)),
                const BodyForm()
              ],
            )
          )
        ),
      ),
    );
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Profile Updated!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}