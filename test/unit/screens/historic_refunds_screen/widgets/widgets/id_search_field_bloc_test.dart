import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/transaction_filter.dart';
import 'package:dashboard/screens/historic_refunds_screen/cubits/filter_button_cubit.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/widgets/widgets/search_bar/widgets/search_field/widgets/id_search_field/bloc/id_search_field_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundsListBloc extends Mock implements RefundsListBloc {}
class MockFilterButtonCubit extends Mock implements FilterButtonCubit {}
class MockRefundsListEvent extends Mock implements RefundsListEvent {}

void main() {
  group("ID Search Field Bloc Tests", () {
    late RefundsListBloc refundsListBloc;
    late FilterButtonCubit filterButtonCubit;
    late IdSearchFieldBloc idSearchFieldBloc;

    late IdSearchFieldState baseState;

    late String _currentId;

    setUp(() {
      refundsListBloc = MockRefundsListBloc();
      filterButtonCubit = MockFilterButtonCubit();
      baseState = IdSearchFieldState.initial();
      idSearchFieldBloc = IdSearchFieldBloc(refundsListBloc: refundsListBloc, filterButtonCubit: filterButtonCubit);
      registerFallbackValue(MockRefundsListEvent());
    });

    tearDown(() {
      idSearchFieldBloc.close();
    });

    test("Initial state of IdSearchFieldBloc is IdSearchFieldState.initial()", () {
      expect(idSearchFieldBloc.state, IdSearchFieldState.initial());
    });
    
    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event changes state: [isFieldValid: isValidId, currentId: event.id]",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        bloc.add(FieldChanged(id: "123"));
      },
      expect: () => [baseState.update(isFieldValid: false, currentId: "123")]
    );

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event only calls refundsListBloc.add when isValidId",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        bloc.add(FieldChanged(id: "12345"));
      },
      verify: (_) {
        verifyNever(() => refundsListBloc.add(any(that: isA<RefundsListEvent>())));
      }
    );

    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event only calls refundsListBloc.add when previousId != event.id",
      build: () => idSearchFieldBloc,
      seed: () {
        _currentId = "67b4655e-27c3-453a-b438-99c53d38735f";
        return IdSearchFieldState(isFieldValid: true, currentId: _currentId);
      },
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        bloc.add(FieldChanged(id: _currentId));
      },
      verify: (_) {
        verifyNever(() => refundsListBloc.add(any(that: isA<RefundsListEvent>())));
      }
    );
    
    blocTest<IdSearchFieldBloc, IdSearchFieldState>(
      "FieldChanged event calls refundsListBloc.add when isValidId && previousId != event.id",
      build: () => idSearchFieldBloc,
      wait: Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        when(() => filterButtonCubit.state).thenReturn(FilterType.refundId);
        bloc.add(FieldChanged(id: "67b4655e-27c3-453a-b438-99c53d38735f"));
      },
      verify: (_) {
        verify(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).called(1);
      }
    );
  });
}