part of 'employee_tip_finder_bloc.dart';

@immutable
class EmployeeTipFinderState extends Equatable {
  final List<EmployeeTip> tips;
  final bool loading;
  final String errorMessage;
  final DateTimeRange? currentDateRange;
  final String currentFirstName;
  final String currentLastName;

  const EmployeeTipFinderState({
    required this.tips,
    required this.loading,
    required this.errorMessage,
    this.currentDateRange,
    required this.currentFirstName,
    required this.currentLastName
  });

  factory EmployeeTipFinderState.initial({@required DateTimeRange? currentDateRange}) {
    return EmployeeTipFinderState(
      tips: [],
      loading: false,
      errorMessage: '',
      currentDateRange: currentDateRange,
      currentFirstName: "",
      currentLastName: ""
    );
  }

  EmployeeTipFinderState update({
    List<EmployeeTip>? tips,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    String? currentFirstName,
    String? currentLastName,
    bool isDateReset = false
  }) {
    return _copyWith(
      tips: tips,
      loading: loading,
      errorMessage: errorMessage,
      currentDateRange: currentDateRange,
      currentFirstName: currentFirstName,
      currentLastName: currentLastName,
      isDateReset: isDateReset
    );
  }
  
  EmployeeTipFinderState _copyWith({
    List<EmployeeTip>? tips,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    String? currentFirstName,
    String? currentLastName,
    required bool isDateReset
  }) {
    return EmployeeTipFinderState(
      tips: tips ?? this.tips,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
      currentFirstName: currentFirstName ?? this.currentFirstName,
      currentLastName: currentLastName ?? this.currentLastName
    );
  }

  @override
  List<Object?> get props => [
    tips,
    loading,
    errorMessage,
    currentDateRange,
    currentFirstName,
    currentLastName,
  ];
  
  @override
  String toString() => '''EmployeeTipFinderState {
    tips: $tips,
    loading: $loading,
    errorMessage: $errorMessage,
    currentDateRange: $currentDateRange,
    currentFirstName: $currentFirstName,
    currentLastName: $currentLastName
  }''';
}
