import 'package:dashboard/providers/geo_provider.dart';
import 'package:location/location.dart';

class GeoRepository {
  final GeoProvider _geoProvider = GeoProvider();

  Future<LocationData> getLocation() async {
    return await _geoProvider.getLocation();
  }

  Future<bool> isEnabled() async {
    return await _geoProvider.enabled();
  }

  Future<bool> requestService() async {
    return await _geoProvider.requestService();
  }

  Future<PermissionStatus> getPermissionStatus() async {
    return await _geoProvider.permissionStatus();
  }

  Future<PermissionStatus> requestPermission() async {
    return await _geoProvider.requestPermission();
  }
}