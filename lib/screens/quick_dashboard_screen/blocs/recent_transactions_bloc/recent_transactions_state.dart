part of 'recent_transactions_bloc.dart';

@immutable
class RecentTransactionsState extends Equatable {
  final List<TransactionResource> transactions;
  final bool loading;
  final String errorMessage;

  const RecentTransactionsState({
    required this.transactions,
    required this.loading,
    required this.errorMessage
  });

  factory RecentTransactionsState.initial() {
    return RecentTransactionsState(
      transactions: [],
      loading: false,
      errorMessage: ""
    );
  }

  RecentTransactionsState update({
    List<TransactionResource>? transactions,
    bool? loading,
    String? errorMessage
  }) {
    return RecentTransactionsState(
      transactions: transactions ?? this.transactions,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    loading,
    errorMessage
  ];
  
  @override
  String toString() => '''RecentTransactionsState {
    transactions: $transactions,
    loading: $loading,
    errorMessage: $errorMessage
  }''';
}
