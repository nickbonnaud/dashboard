import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/widgets/name_field/bloc/name_field_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeTipFinderBloc extends Mock implements EmployeeTipFinderBloc {}
class MockFetch extends Mock implements Fetch {}

void main() {
  group("Name Field Bloc Tests", () {
    late EmployeeTipFinderBloc employeeTipFinderBloc;
    late NameFieldBloc nameFieldBloc;

    late NameFieldState _baseState;

    setUp(() {
      employeeTipFinderBloc = MockEmployeeTipFinderBloc();
      when(() => employeeTipFinderBloc.employeeFirstName).thenReturn("");
      when(() => employeeTipFinderBloc.employeeLastName).thenReturn("");

      nameFieldBloc = NameFieldBloc(employeeTipFinderBloc: employeeTipFinderBloc);
      _baseState = nameFieldBloc.state;

      registerFallbackValue(MockFetch());
    });

    tearDown(() {
      nameFieldBloc.close();
    });

    test("Initial state of NameFieldBloc is NameFieldState.initial()", () {
      expect(nameFieldBloc.state, NameFieldState.initial(firstName: "", lastName: ""));
    });

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes state when invalid first & last: [firstName: firstName, isFirstNameValid: false, lastName: lastName, isLastNameValid: false]",
      build: () => nameFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "f", lastName: "l")),
      expect: () => [_baseState.update(firstName: "f", isFirstNameValid: false, lastName: "l", isLastNameValid: false)]
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event does not call employeeTipFinderBloc.add() state when invalid first & last: [firstName: firstName, isFirstNameValid: false, lastName: lastName, isLastNameValid: false]",
      build: () => nameFieldBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "f", lastName: "l")),
      verify: (_) {
        verifyNever(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>())));
      }
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes state when valid first name: [firstName: firstName, isFirstNameValid: true, lastName: lastName, isLastNameValid: false]",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "first", lastName: "l")),
      expect: () => [_baseState.update(firstName: "first", isFirstNameValid: true, lastName: "l", isLastNameValid: false)]
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes when valid first name calls employeeTipFinderBloc.add()",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "first", lastName: "l")),
      verify: (_) {
        verify(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).called(1);
      }
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes state when valid last name: [firstName: '', isFirstNameValid: false, lastName: lastName, isLastNameValid: true]",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "s", lastName: "last")),
      expect: () => [_baseState.update(firstName: "s", isFirstNameValid: false, lastName: "last", isLastNameValid: true)]
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes when valid last name calls employeeTipFinderBloc.add()",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "s", lastName: "last")),
      verify: (_) {
        verify(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).called(1);
      }
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event changes state when valid whole name: [firstName: first, isFirstNameValid: true, lastName: lastName, isLastNameValid: true]",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "first", lastName: "last")),
      expect: () => [_baseState.update(firstName: "first", isFirstNameValid: true, lastName: "last", isLastNameValid: true)]
    );

    blocTest<NameFieldBloc, NameFieldState>(
      "NameChanged event calls employeeTipFinderBloc.add() when valid whole name: [firstName: first, isFirstNameValid: true, lastName: lastName, isLastNameValid: true]",
      build: () {
        when(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).thenReturn(null);
        return nameFieldBloc;
      },
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(const NameChanged(firstName: "first", lastName: "last")),
      verify: (_) {
        verify(() => employeeTipFinderBloc.add(any(that: isA<EmployeeTipFinderEvent>()))).called(1);
      }
    );
  });
}