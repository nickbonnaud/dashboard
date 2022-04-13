import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/create_profile_screen_body/create_profile_screen_body.dart';
import 'widgets/edit_profile_screen_body.dart';

class ProfileScreenBody extends StatelessWidget {

  const ProfileScreenBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider.of<BusinessBloc>(context).business.profile.identifier.isEmpty 
      ? const CreateProfileScreenBody() 
      : const EditProfileScreenBody();
  }
}