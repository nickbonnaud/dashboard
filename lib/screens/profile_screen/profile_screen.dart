import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';

import 'bloc/profile_screen_bloc.dart';
import 'widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileRepository _profileRepository;
  final GoogleMapsPlaces _places;

  const ProfileScreen({
    required ProfileRepository profileRepository,
    required GoogleMapsPlaces places,
    Key? key
  })
    : _profileRepository = profileRepository,
      _places = places,
      super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _profileScreenBody(context: context),
      appBar: BlocProvider.of<BusinessBloc>(context).business.profile.identifier.isEmpty
        ? AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
        : DefaultAppBar(context: context)
    );
  }

  Widget _profileScreenBody({required BuildContext context}) {
    return BlocProvider<ProfileScreenBloc>(
      create: (context) => ProfileScreenBloc(
        profileRepository: _profileRepository,
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        places: _places
      ),
      child: const ProfileScreenBody()
    );
  }
}