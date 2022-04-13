import 'package:location/location.dart';

class GeoProvider {

  const GeoProvider();

  Future<LocationData> getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }

  Future<bool> enabled() async {
    Location location = Location();
    return await location.serviceEnabled();
  }

  Future<bool> requestService() async {
    Location location = Location();
    return await location.requestService();
  }

  Future<PermissionStatus> permissionStatus() async {
    Location location = Location();
    return await location.hasPermission();
  }

  Future<PermissionStatus> requestPermission() async {
    Location location = Location();
    return await location.requestPermission();
  }
}