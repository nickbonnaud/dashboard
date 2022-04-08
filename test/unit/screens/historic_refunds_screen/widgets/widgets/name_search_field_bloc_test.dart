import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/bloc/refunds_list_bloc.dart';
import 'package:dashboard/screens/historic_refunds_screen/widgets/widgets/widgets/search_bar/widgets/search_field/widgets/name_search_field/bloc/name_search_field_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRefundsListBloc extends Mock implements RefundsListBloc {}
class MockRefundsListEvent extends Mock implements RefundsListEvent {}

void main() {
  group("Name Search Field Bloc Tests", () {
    late RefundsListBloc refundsListBloc;
    late NameSearchFieldBloc nameSearchFieldBloc;

    late NameSearchFieldState baseState;

    late String _firstName;
    late String _lastName;

    setUp(() {
      refundsListBloc = MockRefundsListBloc();
      nameSearchFieldBloc = NameSearchFieldBloc(refundsListBloc: refundsListBloc);
      baseState = NameSearchFieldState.initial();
      registerFallbackValue(MockRefundsListEvent());
    }); 

    tearDown(() {
      nameSearchFieldBloc.close();
    });

    test("Initial state of NameSearchFieldBloc is NameSearchFieldState.initial()", () {
      expect(nameSearchFieldBloc.state, NameSearchFieldState.initial());
    });

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event changes state: [firstName, isFirstNameValid, lastName, isLastNameValid]",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "A";
        _lastName = "B";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      expect: () => [baseState.update(firstName: _firstName, lastName: _lastName, isFirstNameValid: Validators.isValidFirstName(name: _firstName), isLastNameValid: Validators.isValidLastName(name: _lastName))]
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event changes state: [firstName: invalidFirst, lastName: validLast, isFirstNameValid: false, isLastNameValid: true]",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "A";
        _lastName = "Smith";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      expect: () => [baseState.update(firstName: _firstName, lastName: _lastName, isFirstNameValid: Validators.isValidFirstName(name: _firstName), isLastNameValid: Validators.isValidLastName(name: _lastName))]
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event does not call RefundsListBloc.add() if invalid first and last name",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "A";
        _lastName = "S";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verifyNever(() => refundsListBloc.add(any(that: isA<RefundsListEvent>())));
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls RefundsListBloc.add() if valid first name",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "Andrew";
        _lastName = "S";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls RefundsListBloc.add() if valid last name",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "A";
        _lastName = "Smith";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "NameChanged event calls RefundsListBloc.add() if valid first and last name",
      build: () => nameSearchFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) {
        when(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).thenReturn(null);
        _firstName = "Andrew";
        _lastName = "Smith";
        bloc.add(NameChanged(firstName: _firstName, lastName: _lastName));
      },
      verify: (_) {
        verify(() => refundsListBloc.add(any(that: isA<RefundsListEvent>()))).called(1);
      }
    );

    blocTest<NameSearchFieldBloc, NameSearchFieldState>(
      "Reset event changes state to NameSearchFieldState.initial()", 
      build: () => nameSearchFieldBloc,
      act: (bloc) => bloc.add(Reset()),
      expect: () => [NameSearchFieldState.initial()]
    );
  });
}