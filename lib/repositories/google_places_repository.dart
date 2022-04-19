import 'package:dashboard/providers/google_places_provider.dart';
import 'package:google_maps_webservice/places.dart';

class GooglePlacesRepository {
  final GooglePlacesProvider _googlePlacesProvider = const GooglePlacesProvider();

  const GooglePlacesRepository();

  Future<PlacesAutocompleteResponse> autoComplete({required String query}) async {
    return _googlePlacesProvider.autoComplete(query: query);
  }

  Future<PlacesDetailsResponse> details({required String placeId}) async {
    return _googlePlacesProvider.details(placeId: placeId);
  }
}