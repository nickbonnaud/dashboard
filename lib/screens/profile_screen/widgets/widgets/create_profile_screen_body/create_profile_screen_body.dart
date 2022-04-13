import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'widgets/place_form.dart';
import '../body_form.dart';

class CreateProfileScreenBody extends StatelessWidget {

  const CreateProfileScreenBody({Key? key})
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
            child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: SizeConfig.getHeight(10)),
                    _title(state: state, context: context),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    _formBody(state: state)
                  ],
                );
              }
            )
          )
        ),
      ),
    );
  }

  Widget _title({required ProfileScreenState state, required BuildContext context}) {
    return Column(
      children: [
        BoldText3(text: "Business Info", context: context),
        state.selectedPrediction == null
          ? Text5(text: "First let's get your businesses name.", context: context)
          : Text5(text: "Next, some basic info about your business.", context: context),
      ],
    );
  }

  _formBody({required ProfileScreenState state}) {
    if (state.selectedPrediction == null) {
      return const PlaceForm();
    }
    final Profile profile = Profile(
      name: state.selectedPrediction!.name,
      website: state.selectedPrediction!.website ?? "",
      phone: state.selectedPrediction!.formattedPhoneNumber ?? "",
      description: "",
      googlePlaceId: null,
      hours: Hours.empty(),
      identifier: ""
    );
    return BodyForm(profile: profile);
  }

  void _showSuccess({required BuildContext context}) {   
    ToastMessage(
      context: context,
      message: "Profile Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}