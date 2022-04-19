import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/google_places_repository.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_screen_bloc.dart';
import 'widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({Key? key})
    : super(key: key);

  
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
        profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        places: RepositoryProvider.of<GooglePlacesRepository>(context)
      ),
      child: const ProfileScreenBody()
    );
  }
}