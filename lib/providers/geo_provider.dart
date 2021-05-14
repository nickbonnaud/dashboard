import 'package:location/location.dart';

class GeoProvider {
  final Location _location = Location();

  Future<LocationData> getLocation() async {
    return await _location.getLocation();
  }

  Future<bool> enabled() async {
    return await _location.serviceEnabled();
  }

  Future<bool> requestService() async {
    return await _location.requestService();
  }

  Future<PermissionStatus> permissionStatus() async {
    return await _location.hasPermission();
  }

  Future<PermissionStatus> requestPermission() async {
    return await _location.requestPermission();
  }
}