import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/providers/hours_provider.dart';
import 'package:dashboard/repositories/base_repository.dart';

class HoursRepository extends BaseRepository {
  final HoursProvider? _hoursProvider;

  const HoursRepository({HoursProvider? hoursProvider})
    : _hoursProvider = hoursProvider;
  
  Future<Hours> store({
    required String sunday,
    required String monday,
    required String tuesday,
    required String wednesday,
    required String thursday,
    required String friday,
    required String saturday
  }) async {
    Map<String, String> body = {
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday
    };

    HoursProvider hoursProvider = _getHoursProvider();
    Map<String, dynamic> json = await send(request: hoursProvider.store(body: body));
    return deserialize(json: json);
  }

  Future<Hours> update({
    required String identifier,
    required String sunday,
    required String monday,
    required String tuesday,
    required String wednesday,
    required String thursday,
    required String friday,
    required String saturday
  }) async {
    Map<String, String> body = {
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday
    };

    HoursProvider hoursProvider = _getHoursProvider();
    Map<String, dynamic> json = await send(request: hoursProvider.update(body: body, identifier: identifier));
    return deserialize(json: json);
  }

  HoursProvider _getHoursProvider() {
    return _hoursProvider ?? const HoursProvider();
  }
  
  @override
  deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json}) {
    return Hours.fromJson(json: json!);
  }
}