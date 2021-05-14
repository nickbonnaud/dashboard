import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:dashboard/screens/owners_screen/widgets/owner_form/bloc/owner_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_animations/simple_animations.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}
class MockOwnersScreenBloc extends Mock implements OwnersScreenBloc {}
class MockOwnerAccount extends Mock implements OwnerAccount {}

void main() {
  group("Owner Form Bloc Tests", () {
    late OwnerRepository ownerRepository;
    late OwnersScreenBloc ownersScreenBloc;
    late OwnerFormBloc ownerFormBloc;

    late OwnerFormState _baseState;

    setUp(() {
      ownerRepository = MockOwnerRepository();
      ownersScreenBloc = MockOwnersScreenBloc();
      ownerFormBloc = OwnerFormBloc(ownerRepository: ownerRepository, ownersScreenBloc: ownersScreenBloc);
      _baseState = ownerFormBloc.state;
      registerFallbackValue<OwnersScreenEvent>(OwnerAdded(owner: MockOwnerAccount()));
      registerFallbackValue<OwnersScreenEvent>(OwnerUpdated(owner: MockOwnerAccount()));
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
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(FirstNameChanged(firstName: "a")),
      expect: () => [_baseState.update(isFirstNameValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "LastNameChanged event changes state: [isLastNameValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(LastNameChanged(lastName: "a")),
      expect: () => [_baseState.update(isLastNameValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "TitleChanged event changes state: [isTitleValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(TitleChanged(title: "s")),
      expect: () => [_baseState.update(isTitleValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "PhoneChanged event changes state: [isPhoneValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PhoneChanged(phone: "fh36ka*^%dd3")),
      expect: () => [_baseState.update(isPhoneValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "EmailChanged event changes state: [isEmailValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(EmailChanged(email: "email?^)23ds")),
      expect: () => [_baseState.update(isEmailValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "isPrimary event changes state: [isPrimary: true]",
      build: () => ownerFormBloc,
      act: (bloc) => bloc.add(PrimaryChanged(isPrimary: true)),
      expect: () => [_baseState.update(isPrimary: true)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "PercentOwnershipChanged event changes state: [isPercentOwnershipValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(PercentOwnershipChanged(percentOwnership: 200)),
      expect: () => [_baseState.update(isPercentOwnershipValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "DobChanged event changes state: [isDobValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(DobChanged(dob: "&2mv/22/198y")),
      expect: () => [_baseState.update(isDobValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "SsnChanged event changes state: [isSsnValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(SsnChanged(ssn: "*hh-u8-od%s")),
      expect: () => [_baseState.update(isSsnValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "AddressChanged event changes state: [isAddressValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(AddressChanged(address: "!")),
      expect: () => [_baseState.update(isAddressValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "AddressSecondaryChanged event changes state: [isAddressSecondaryValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(AddressSecondaryChanged(addressSecondary: "&")),
      expect: () => [_baseState.update(isAddressSecondaryValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "CityChanged event changes state: [isCityValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(CityChanged(city: "&h")),
      expect: () => [_baseState.update(isCityValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "StateChanged event changes state: [isStateValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(StateChanged(state: "O*")),
      expect: () => [_baseState.update(isStateValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "ZipChanged event changes state: [isZipValid: false]",
      build: () => ownerFormBloc,
      wait: Duration(milliseconds: 300),
      act: (bloc) => bloc.add(ZipChanged(zip: "8hd3h*")),
      expect: () => [_baseState.update(isZipValid: false)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted(firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event calls ownerRepository.store()",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted(firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      verify: (_) {
        verify(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event calls ownersScreenBloc.add()",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted(firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      verify: (_) {
        verify(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Submitted event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.store(firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenThrow(ApiException(error: "error"));
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Submitted(firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event changes state: [isSubmitting: true], [isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP]",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: "identifier", firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event calls ownerRepository.update()",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: "identifier", firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      verify: (_) {
        verify(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip"))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event calls ownersScreenBloc.add()",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenAnswer((_) async => MockOwnerAccount());
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: "identifier", firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      verify: (_) {
        verify(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).called(1);
      }
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Updated event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START]",
      build: () => ownerFormBloc,
      act: (bloc) {
        when(() => ownerRepository.update(identifier: any(named: "identifier"), firstName: any(named: "firstName"), lastName: any(named: "lastName"), title: any(named: "title"), phone: any(named: "phone"), email: any(named: "email"), primary: any(named: "primary"), percentOwnership: any(named: "percentOwnership"), dob: any(named: "dob"), ssn: any(named: "ssn"), address: any(named: "address"), addressSecondary: any(named: "addressSecondary"), city: any(named: "city"), state: any(named: "state"), zip: any(named: "zip")))
          .thenThrow(ApiException(error: "error"));
        when(() => ownersScreenBloc.add(any(that: isA<OwnersScreenEvent>()))).thenReturn(null);
        bloc.add(Updated(identifier: "identifier", firstName: "firstName", lastName: "lastName", title: "title", phone: "phone", email: "email", primary: false, percentOwnership: "25", dob: "dob", ssn: "ssn", address: "address", addressSecondary: "addressSecondary", city: "city", state: "state", zip: "zip"));
      },
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START)]
    );

    blocTest<OwnerFormBloc, OwnerFormState>(
      "Reset event changes state: [isFirstNameValid: false]",
      build: () => ownerFormBloc,
      seed: () => _baseState.update(isSuccess: true, errorMessage: "error", errorButtonControl: CustomAnimationControl.PLAY_FROM_START),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP)]
    );
  });
}