import 'package:bloc/bloc.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/tips_screen/widgets/widgets/employee_tip_finder/bloc/employee_tip_finder_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'name_field_event.dart';
part 'name_field_state.dart';

class NameFieldBloc extends Bloc<NameFieldEvent, NameFieldState> {
  final EmployeeTipFinderBloc _employeeTipFinderBloc;
  
  NameFieldBloc({required EmployeeTipFinderBloc employeeTipFinderBloc})
    : _employeeTipFinderBloc = employeeTipFinderBloc,
      super(NameFieldState.initial(
        firstName: employeeTipFinderBloc.employeeFirstName,
        lastName: employeeTipFinderBloc.employeeLastName
      )) { _eventHandler(); }

  void _eventHandler() {
    on<NameChanged>((event, emit) => _mapNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(seconds: 1)));
  }
  
  void _mapNameChangedToState({required NameChanged event, required Emitter<NameFieldState> emit}) async {
    final String previousFirstName = state.firstName;
    final String previousLastName = state.lastName;
    final bool isValidFirstName = Validators.isValidFirstName(name: event.firstName);
    final bool isValidLastName = Validators.isValidLastName(name: event.lastName);
    final bool firstNameChanged = previousFirstName != event.firstName;
    final bool lastNameChanged = previousLastName != event.lastName;

    emit(state.update(firstName: event.firstName, isFirstNameValid: isValidFirstName, lastName: event.lastName, isLastNameValid: isValidLastName));
    
    if (firstNameChanged && (isValidFirstName || event.firstName.length == 0)) {
      final String? lastName = isValidLastName ? event.lastName : null;
      
      if (isValidFirstName || isValidLastName) {
        _updateQuery(firstName: event.firstName, lastName: lastName);
      }
    } else if (lastNameChanged && (isValidLastName || event.lastName.length ==0)) {
      final String? firstName = isValidFirstName ? event.firstName : null;
      
      if (isValidFirstName || isValidLastName) {
        _updateQuery(firstName: firstName, lastName: event.lastName);
      }
    }
  }

  void _updateQuery({@required String? firstName, @required String? lastName}) {
    _employeeTipFinderBloc.add(Fetch(firstName: firstName, lastName: lastName));
  }
}
