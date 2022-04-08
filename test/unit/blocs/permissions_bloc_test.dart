import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/permissions/permissions_bloc.dart';
import 'package:dashboard/repositories/geo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';

class MockGeoRepository extends Mock implements GeoRepository {}

void main() {
  
  group("Permissions Bloc Tests", () {
    late GeoRepository geoRepository;
    late PermissionsBloc permissionsBloc;

    setUp(() {
      geoRepository = MockGeoRepository();
      permissionsBloc = PermissionsBloc(geoRepository: geoRepository);
    });

    tearDown(() {
      permissionsBloc.close();
    });

    test("PermissionsBloc intial state is PermissionsState.initial()", () {
      expect(permissionsBloc.state, PermissionsState.initial());
    });

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc event Init calls isEnabled and getPermissionsStatus", 
      build: () {
        when(() => geoRepository.isEnabled()).thenAnswer((_) async => true);
        when(() => geoRepository.getPermissionStatus()).thenAnswer((_) async => PermissionStatus.granted);
        return permissionsBloc;
      },
      act: (bloc) => bloc.add(Init()),
      verify: (_) {
        verify(() => geoRepository.isEnabled()).called(1);
        verify(() => geoRepository.getPermissionStatus()).called(1);
      }
    );

    blocTest<PermissionsBloc, PermissionsState>(
      "PermissionsBloc event Init yields [loading=true], [loading=false, isGeoEnabled=true, hasGeoPermission=true]", 
      build: () {
        when(() => geoRepository.isEnabled()).thenAnswer((_) async => true);
        when(() => geoRepository.getPermissionStatus()).thenAnswer((_) async => PermissionStatus.granted);
        return permissionsBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        const PermissionsState(loading: true, isGeoEnabled: false, hasGeoPermission: false),
        const PermissionsState(loading: false, isGeoEnabled: true, hasGeoPermission: true),
      ]
    );
  });
}