import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/geo_account_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class GeoAccountRepository extends BaseRepository {
  final GeoAccountProvider? _geoAccountProvider;

  const GeoAccountRepository({GeoAccountProvider? geoAccountProvider})
    : _geoAccountProvider = geoAccountProvider;
  
  Future<Location> store({required double lat, required double lng, required int radius}) async {
    Map<String, dynamic> body = {
      'lat': lat,
      'lng': lng,
      'radius': radius
    };
    
    GeoAccountProvider geoAccountProvider = _getGeoAccountProvider();
    Map<String, dynamic> json = await send(request: geoAccountProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Location> update({required String identifier, required double lat, required double lng, required int radius}) async {
    Map<String, dynamic> body = {
      'lat': lat,
      'lng': lng,
      'radius': radius
    };

    GeoAccountProvider geoAccountProvider = _getGeoAccountProvider();
    Map<String, dynamic> json = await send(request: geoAccountProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  GeoAccountProvider _getGeoAccountProvider() {
    return _geoAccountProvider ?? const GeoAccountProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Location.fromJson(json: json!);
  }
}