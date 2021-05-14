part of 'unassigned_transactions_list_bloc.dart';

class UnassignedTransactionsListState extends Equatable {
  final List<UnassignedTransaction> transactions;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final String errorMessage;
  final DateTimeRange? currentDateRange;

  UnassignedTransactionsListState({
    required this.transactions,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.errorMessage,
    this.currentDateRange
  });

  factory UnassignedTransactionsListState.initial({@required DateTimeRange? currentDateRange}) {
    return UnassignedTransactionsListState(
      transactions: [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: false,
      errorMessage: '',
      currentDateRange: currentDateRange,
    );
  }

  UnassignedTransactionsListState update({
    List<UnassignedTransaction>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    bool isDateReset = false
  }) {
    return _copyWith(
      transactions: transactions,
      nextUrl: nextUrl,
      hasReachedEnd: hasReachedEnd,
      loading: loading,
      errorMessage: errorMessage,
      currentDateRange: currentDateRange,
      isDateReset: isDateReset
    );
  }
  
  UnassignedTransactionsListState _copyWith({
    List<UnassignedTransaction>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    required bool isDateReset
  }) {
    return UnassignedTransactionsListState(
      transactions: transactions ?? this.transactions,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null :  nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    nextUrl,
    hasReachedEnd,
    loading,
    errorMessage,
    currentDateRange,
  ];
  
  @override
  String toString() => '''UnassignedTransactionsListState {
    transactions: $transactions,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    errorMessage: $errorMessage,
    currentDateRange: $currentDateRange,
  }''';
}
