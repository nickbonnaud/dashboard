import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/screens/geo_account_screen/bloc/geo_account_screen_bloc.dart';
import 'package:dashboard/screens/geo_account_screen/widgets/geo_account_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeoAccountScreen extends StatelessWidget {
  final bool _isEdit;

  const GeoAccountScreen.new({Key? key})
    : _isEdit = false,
      super(key: key);

  const GeoAccountScreen.edit({Key? key})
    : _isEdit = true,
      super(key: key); 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _geoAccountScreenBody(context: context),
      appBar: _isEdit
        ? DefaultAppBar(context: context)
        : AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
    );
  }

  Widget _geoAccountScreenBody({required BuildContext context}) {
    return BlocProvider<GeoAccountScreenBloc>(
      create: (context) => GeoAccountScreenBloc(
        accountRepository: RepositoryProvider.of<GeoAccountRepository>(context),
        businessBloc: BlocProvider.of<BusinessBloc>(context),
        location: BlocProvider.of<BusinessBloc>(context).business.location
      ),
      child: GeoAccountScreenBody(isEdit: _isEdit),
    );
  }
}