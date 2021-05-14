part of 'permissions_bloc.dart';

@immutable
class PermissionsState extends Equatable {
  final bool loading;
  final bool isGeoEnabled;
  final bool hasGeoPermission;

  PermissionsState({
    required this.isGeoEnabled,
    required this.hasGeoPermission,
    required this.loading
  });

  factory PermissionsState.initial() {
    return PermissionsState(
      isGeoEnabled: false, 
      hasGeoPermission: false,
      loading: true
    );
  }

  PermissionsState update({
    bool? isGeoEnabled, 
    bool? hasGeoPermission,
    bool? loading
  }) {
    return PermissionsState(
      isGeoEnabled: isGeoEnabled ?? this.isGeoEnabled,
      hasGeoPermission: hasGeoPermission ?? this.hasGeoPermission,
      loading: loading ?? this.loading
    );
  }

  @override
  List<Object?> get props => [loading, isGeoEnabled, hasGeoPermission];

  @override
  String toString() => 'PermissionsState { loading: $loading, isGeoEnabled: $isGeoEnabled, hasGeoPermission: $hasGeoPermission }';
}

