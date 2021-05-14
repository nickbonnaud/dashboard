import 'package:dashboard/models/paginated_api_response.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/providers/status_provider.dart';
import 'package:dashboard/repositories/status_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStatusProvider extends Mock implements StatusProvider {}

void main() {
  group("Status Repository Tests", () {
    late StatusRepository _statusRepository;
    late StatusProvider _mockStatusProvider;
    late StatusRepository _statusRepositoryWithMock;

    setUp(() {
      _statusRepository = StatusRepository(statusProvider: StatusProvider());
      _mockStatusProvider = MockStatusProvider();
      _statusRepositoryWithMock = StatusRepository(statusProvider: _mockStatusProvider);
    });
    
    test("Status Repository can Fetch Transaction Statuses", () async {
      var statuses = await _statusRepository.fetchTransactionStatuses();
      expect(statuses is List<Status>, true);
    });

    test("Status Repository throws error on Fetch Transaction Statuses fail", () async {
      when(() => _mockStatusProvider.fetchTransactionStatuses()).thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false, error: "error", next: null));
      
      expect(
        _statusRepositoryWithMock.fetchTransactionStatuses(), 
        throwsA(isA<ApiException>())
      );
    });
  });
}