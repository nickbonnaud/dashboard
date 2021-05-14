import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/blocs/permissions/permissions_bloc.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/geo_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phase_two.dart';

class PhaseOne extends StatelessWidget {
  final MaterialApp? _testApp;
  final BusinessRepository _businessRepository = BusinessRepository(businessProvider: BusinessProvider(), tokenRepository: TokenRepository());
  final GeoRepository _geoRepository = GeoRepository();

  PhaseOne({MaterialApp? testApp})
    : _testApp = testApp;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessBloc>(
          create: (_) => BusinessBloc(
            businessRepository: _businessRepository
          ),
        ),

        BlocProvider<PermissionsBloc>(
          create: (_) => PermissionsBloc(geoRepository: _geoRepository)
            ..add(Init()),
        )
      ], 
      child: PhaseTwo(testApp: _testApp)
    );
  }
}