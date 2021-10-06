import 'package:bloc/bloc.dart';
import 'package:dashboard/repositories/geo_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final GeoRepository _geoRepository;

  PermissionsBloc({required GeoRepository geoRepository}) 
    : _geoRepository = geoRepository,
      super(PermissionsState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(emit: emit));
  }

  void _mapInitToState({required Emitter<PermissionsState> emit}) async {
    emit(state.update(loading: true));
    List responses = await Future.wait([_geoRepository.isEnabled(), _geoRepository.getPermissionStatus()]);
    emit(state.update(
      loading: false,
      isGeoEnabled: responses.first,
      hasGeoPermission: responses.last == PermissionStatus.granted
    ));
  }
}
