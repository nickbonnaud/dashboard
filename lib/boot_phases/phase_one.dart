import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/blocs/permissions/permissions_bloc.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/geo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phase_two.dart';

class PhaseOne extends StatelessWidget {
  final MaterialApp? _testApp;

  const PhaseOne({MaterialApp? testApp, Key? key})
    : _testApp = testApp,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessBloc>(
          create: (_) => BusinessBloc(
            businessRepository: const BusinessRepository()
          ),
        ),

        BlocProvider<PermissionsBloc>(
          create: (_) => PermissionsBloc(
            geoRepository: const GeoRepository()
          )..add(Init()),
        )
      ], 
      child: PhaseTwo(testApp: _testApp)
    );
  }
}