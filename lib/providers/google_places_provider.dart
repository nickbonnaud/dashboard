import 'package:google_maps_webservice/places.dart';

import '../dev_keys.dart';

class GooglePlacesProvider {

  const GooglePlacesProvider();

  
  Future<PlacesAutocompleteResponse> autoComplete({required String query}) async {
    GoogleMapsPlaces places = _initPlaces();

    return places.autocomplete(query, types: ['establishment']);
  }

  Future<PlacesDetailsResponse> details({required String placeId}) async {
    GoogleMapsPlaces places = _initPlaces();

    return places.getDetailsByPlaceId(placeId);
  }
  
  GoogleMapsPlaces _initPlaces() {
    return GoogleMapsPlaces(
      apiKey: DevKeys.googleKey,
      baseUrl: 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
    );
  }
}