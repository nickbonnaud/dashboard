import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:dashboard/screens/owners_screen/widgets/owner_form/bloc/owner_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../../helpers/mock_data_generator.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}
class MockOwnersScreenBloc extends Mock implements OwnersScreenBloc {}
class MockOwnerAccount extends Mock implements OwnerAccount {}

void main() {
  group("Owner Form Bloc Tests", () {
    late MockDataGenerator mockDataGenerator;
    late OwnerRepository ownerRepository;
    late OwnersScreenBloc ownersScreenBloc;
    late OwnerFormBloc ownerFormBloc;
    late OwnerFormBloc ownerFormBlocEdit;

    late OwnerFormState _baseState;
    late OwnerFormState _baseStateEdit;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      ownerRepository = MockOwnerRepository();
      ownersScreenBloc = MockOwnersScreenBloc();
      ownerFormBloc = OwnerFormBloc(ownerRepository: ownerRepository, ownersScreenBloc: ownersScreenBloc);
      ownerFormBlocEdit = OwnerFormBloc(ownerRepository: ownerRepository, ownersScreenBloc: ownersScreenBloc, ownerAccount: mockDataGenerator.createOwner(index: 0));
      _baseState = ownerFormBloc.state;
      _baseStateEdit = ownerFormBlocEdit.state;
      registerFallbackValue(OwnerAdded(owner: MockOwnerAccount()));
      registerFallbackValue(OwnerUpdated(owner: MockOwnerAccount()));
    });

    tearDown(() {
      ownerFormBloc.close();
    });

    test("Initial state of OwnerFormBloc is OwnerFormState.empty()", () {
      expect(ownerFormBloc.state, OwnerFormState.empty());
    });

    blocTest<OwnerFormBloc, OwnerFormState>(
      "FirstNameChanged event changes state: [isFirstNameValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const FirstNameChanged(firstName: "a")),
      expect: () => [_baseState.update(firstName: 'a', isFirstNameValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "LastNameChanged event changes state: [isLastNameValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const LastNameChanged(lastName: "a")),
      expect: () => [_baseState.update(lastName: 'a', isLastNameValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "TitleChanged event changes state: [isTitleValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const TitleChanged(title: "s")),
      expect: () => [_baseState.update(title: 's', isTitleValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "PhoneChanged event changes state: [isPhoneValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const PhoneChanged(phone: "fh36ka*^%dd3")),
      expect: () => [_baseState.update(phone: "fh36ka*^%dd3", isPhoneValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "EmailChanged event changes state: [isEmailValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const EmailChanged(email: "email?^)23ds")),
      expect: () => [_baseState.update(email: "email?^)23ds", isEmailValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "isPrimary event changes state: [isPrimary: true]",
      build: () => ownerFormBloc,
      act: (bloc) => bloc.add(const PrimaryChanged(isPrimary: true)),
      expect: () => [_baseState.update(isPrimary: true)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "PercentOwnershipChanged event changes state: [isPercentOwnershipValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const PercentOwnershipChanged(percentOwnership: 200)),
      expect: () => [_baseState.update(percentOwnership: '200', isPercentOwnershipValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "DobChanged event changes state: [isDobValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const DobChanged(dob: "&2mv/22/198y")),
      expect: () => [_baseState.update(dob: "&2mv/22/198y", isDobValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "SsnChanged event changes state: [isSsnValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const SsnChanged(ssn: "*hh-u8-od%s")),
      expect: () => [_baseState.update(ssn: "*hh-u8-od%s", isSsnValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "AddressChanged event changes state: [isAddressValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const AddressChanged(address: "!")),
      expect: () => [_baseState.update(address: "!", isAddressValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "AddressSecondaryChanged event changes state: [isAddressSecondaryValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const AddressSecondaryChanged(addressSecondary: "&")),
      expect: () => [_baseState.update(addressSecondary: "&", isAddressSecondaryValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "CityChanged event changes state: [isCityValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const CityChanged(city: "&h")),
      expect: () => [_baseState.update(city: "&h", isCityValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "StateChanged event changes state: [isStateValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const StateChanged(state: "O*")),
      expect: () => [_baseState.update(state: "O*", isStateValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "ZipChanged event changes state: [isZipValid: false]",
      build: () => ownerFormBloc,
      wait: const Duration(milliseconds: 300),
      act: (bloc) => bloc.add(const ZipChanged(zip: "8hd3h*")),
      expect: () => [_baseState.update(zip: "8hd3h*", isZipValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => ownerFormBloc,
      seed: () {
        _baseState = OwnerFormState.empty(ownerAccount: mockDataGenerator.createOwner(index: 0));
        return _baseState;
      },
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event calls ownerRepository.store()",
      build: () => ownerFormBloc,
      seed: () {
        _baseState = OwnerFormState.empty(ownerAccount: mockDataGenerator.createOwner(index: 0));
        return _baseState;
      },
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event calls ownersScreenBloc.add()",
      build: () => ownerFormBloc,
      seed: () {
        _baseState = OwnerFormState.empty(ownerAccount: mockDataGenerator.createOwner(index: 0));
        return _baseState;
      },
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      verify: (_) {
        verify(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => ownerFormBloc,
      seed: () {
        _baseState = OwnerFormState.empty(ownerAccount: mockDataGenerator.createOwner(index: 0));
        return _baseState;
      },
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenThrow(const ApiException(error: "error"));
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted());
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => ownerFormBlocEdit,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      expect: () => [_baseStateEdit.update(isSubmitting: true), _baseStateEdit.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event calls ownerRepository.update()",
      build: () => ownerFormBlocEdit,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip"))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event calls ownersScreenBloc.add()",
      build: () => ownerFormBlocEdit,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      verify: (_) {
        verify(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => ownerFormBlocEdit,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenThrow(const ApiException(error: "error"));
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated());
      },
      expect: () => [_baseStateEdit.update(isSubmitting: true), _baseStateEdit.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Reset event changes state: [isFirstNameValid: false]",
      build: () => ownerFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.playFromStart),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop)]
    );
  });
}