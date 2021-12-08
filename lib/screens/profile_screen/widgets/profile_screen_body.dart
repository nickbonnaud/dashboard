import 'package:dashboard/models/business/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_screen_bloc.dart';
import 'widgets/create_profile_screen_body/create_profile_screen_body.dart';
import 'widgets/edit_profile_screen_body.dart';

class ProfileScreenBody extends StatefulWidget {
  final Profile _profile;

  const ProfileScreenBody({required Profile profile})
    : _profile = profile;

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}
  
class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  late ProfileScreenBloc _profileScreenBloc;
  
  @override
  void initState() {
    super.initState();
    _profileScreenBloc = BlocProvider.of<ProfileScreenBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return widget._profile.identifier.isEmpty 
      ? CreateProfileScreenBody(profileScreenBloc: _profileScreenBloc) 
      : EditProfileScreenBody(profile: widget._profile, profileScreenBloc: _profileScreenBloc);
  }

  @override
  void dispose() {
    _profileScreenBloc.close();
    super.dispose();
  }
}