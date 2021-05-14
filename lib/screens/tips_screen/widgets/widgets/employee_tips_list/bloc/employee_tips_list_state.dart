part of 'employee_tips_list_bloc.dart';

@immutable
class EmployeeTipsListState extends Equatable {
  final List<EmployeeTip> tips;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final String errorMessage;
  final DateTimeRange? currentDateRange;

  const EmployeeTipsListState({
    required this.tips,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.errorMessage,
    required this.currentDateRange,
  });

  factory EmployeeTipsListState.initial({@required DateTimeRange? currentDateRange}) {
    return EmployeeTipsListState(
      tips: [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: false,
      errorMessage: '',
      currentDateRange: currentDateRange,
    );
  }

  EmployeeTipsListState update({
    List<EmployeeTip>? tips,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    bool isDateReset = false
  }) {
    return _copyWith(
      tips: tips,
      nextUrl: nextUrl,
      hasReachedEnd: hasReachedEnd,
      loading: loading,
      errorMessage: errorMessage,
      currentDateRange: currentDateRange,
      isDateReset: isDateReset
    );
  }
  
  EmployeeTipsListState _copyWith({
    List<EmployeeTip>? tips,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    required bool isDateReset
  }) {
    return EmployeeTipsListState(
      tips: tips ?? this.tips,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
    );
  }

  @override
  List<Object?> get props => [
    tips,
    nextUrl,
    hasReachedEnd,
    loading,
    errorMessage,
    currentDateRange,
  ];
  
  @override
  String toString() => '''EmployeeTipsListState {
    tips: $tips,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    errorMessage: $errorMessage,
    currentDateRange: $currentDateRange,
  }''';
}
