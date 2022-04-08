import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/screens/geo_account_screen/bloc/geo_account_screen_bloc.dart';
import 'package:dashboard/screens/geo_account_screen/widgets/geo_account_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeoAccountScreen extends StatelessWidget {
  final GeoAccountRepository _geoAccountRepository;
  final BusinessBloc _businessBloc;
  final Location _location;
  final bool _isEdit;

  const GeoAccountScreen({
    required GeoAccountRepository geoAccountRepository,
    required BusinessBloc businessBloc,
    required Location location,
    required bool isEdit,
    Key? key
  })
    : _geoAccountRepository = geoAccountRepository,
      _businessBloc = businessBloc,
      _location = location,
      _isEdit = isEdit,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _isEdit
      ? Scaffold(
          appBar: DefaultAppBar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _geoAccountScreenBody(context: context),
        )
      : Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _geoAccountScreenBody(context: context),
        );
  }

  Widget _geoAccountScreenBody({required BuildContext context}) {
    return BlocProvider<GeoAccountScreenBloc>(
      create: (context) => GeoAccountScreenBloc(
        accountRepository: _geoAccountRepository,
        businessBloc: _businessBloc,
        location: _location
      ),
      child: GeoAccountScreenBody(location: _location, isEdit: _isEdit),
    );
  }
}