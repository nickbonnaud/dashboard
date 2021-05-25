import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/receipt_screen_unassigned/receipt_screen_unassigned.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class UnassignedTransactionWidget extends StatelessWidget {
  final UnassignedTransaction _unassignedTransaction;
  final int _index;

  const UnassignedTransactionWidget({required UnassignedTransaction unassignedTransaction, required int index})
    : _unassignedTransaction = unassignedTransaction,
      _index = index;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("unassignedTransactionsCard-$_index"),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            Icons.person,
          ),
        ),
        title: Text4(
          text: "Total: ${Currency.create(cents: _unassignedTransaction.transaction.total)}", 
          context: context
        ),
        subtitle: _unassignedTransaction.employee != null
          ? Text5(
              text: "Employee: ${_unassignedTransaction.employee!.firstName} ${_unassignedTransaction.employee!.lastName}", 
              context: context
            )
          : null,
        trailing: Text5(
          text: DateFormatter.toStringDateTime(date: _unassignedTransaction.transaction.createdAt),
          context: context,
          color: Theme.of(context).colorScheme.onPrimarySubdued,
        ),
        onTap: () => _showFullTransaction(context: context),
      ),
    );
  }

  void _showFullTransaction({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute<ReceiptScreenUnassigned>(
      fullscreenDialog: true,
      builder: (_) => ReceiptScreenUnassigned(unassignedTransaction: _unassignedTransaction)
    ));
  }
}