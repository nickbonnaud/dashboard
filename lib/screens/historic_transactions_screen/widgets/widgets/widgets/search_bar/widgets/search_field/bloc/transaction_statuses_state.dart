part of 'transaction_statuses_bloc.dart';

@immutable
class TransactionStatusesState extends Equatable {
  final List<Status> statuses;
  final bool loading;
  final bool fetchFailed;
  
  TransactionStatusesState({
    required this.statuses,
    required this.loading,
    required this.fetchFailed
  });

  factory TransactionStatusesState.initial() {
    return TransactionStatusesState(
      statuses: Constants.defaultStatuses,
      loading: false,
      fetchFailed: false
    );
  }

  TransactionStatusesState update({
    List<Status>? statuses,
    bool? loading,
    bool? fetchFailed
  }) {
    return _copyWith(
      statuses: statuses,
      loading: loading,
      fetchFailed: fetchFailed
    );
  }

  TransactionStatusesState _copyWith({
    List<Status>? statuses,
    bool? loading,
    bool? fetchFailed
  }) {
    return TransactionStatusesState(
      statuses: statuses ?? this.statuses,
      loading: loading ?? this.loading,
      fetchFailed: fetchFailed ?? this.fetchFailed
    );
  }

  @override
  List<Object?> get props => [statuses, loading, fetchFailed];

  @override
  String toString() => "TransactionStatusesState { statuses: $statuses, loading: $loading, fetchFailed: $fetchFailed }";
}
