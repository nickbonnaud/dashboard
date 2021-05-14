import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/screens/profile_screen/widgets/edit_profile_screen_body/edit_profile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';

import 'bloc/profile_screen_bloc.dart';
import 'widgets/create_profile_screen_body/create_profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileRepository _profileRepository;
  final Profile _profile;
  final BusinessBloc _businessBloc;
  final GoogleMapsPlaces _places;

  const ProfileScreen({
    required ProfileRepository profileRepository,
    required Profile profile,
    required BusinessBloc businessBloc,
    required GoogleMapsPlaces places
  })
    : _profileRepository = profileRepository,
      _profile = profile,
      _businessBloc = businessBloc,
      _places = places;
  
  @override
  Widget build(BuildContext context) {
    return _profile.identifier.isEmpty
      ? Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _profileScreenBody(context: context),
        )
      : Scaffold(
          appBar: DefaultAppBar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _profileScreenBody(context: context),
        );
  }

  Widget _profileScreenBody({required BuildContext context}) {
    return BlocProvider<ProfileScreenBloc>(
      create: (context) => ProfileScreenBloc(
        profileRepository: _profileRepository,
        businessBloc: _businessBloc,
        places: _places
      ),
      child: _profile.identifier.isEmpty 
        ? CreateProfileScreenBody() 
        : EditProfileScreenBody(profile: _profile)
    );
  }
}