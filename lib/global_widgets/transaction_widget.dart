import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/receipt_screen/receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class TransactionWidget extends StatelessWidget {
  final int _index;
  final TransactionResource _transactionResource;

  const TransactionWidget({
    required int index,
    required TransactionResource transactionResource,
    Key? key
  })
    : _index = index,
      _transactionResource = transactionResource,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("transaction-$_index"),
      child: ListTile(
        leading: Hero(
          tag: _transactionResource.transaction.identifier, 
          child: CircleAvatar(
            backgroundImage: NetworkImage(_transactionResource.customer.photo.largeUrl),
            backgroundColor: Colors.transparent,
          )
        ),
        title: Text4(
          text: "${_transactionResource.customer.firstName} ${_transactionResource.customer.lastName}",
          context: context,
        ),
        subtitle: Text5(
          text: "Total: ${Currency.create(cents: _transactionResource.transaction.total)}",
          context: context,
        ),
        trailing: Text5(
          text: DateFormatter.toStringDateTime(date: _transactionResource.transaction.updatedAt),
          context: context,
          color: Theme.of(context).colorScheme.onPrimarySubdued,
        ),
        onTap: () => _showFullTransaction(context: context),
      ),
    );
  }

  void _showFullTransaction({required BuildContext context}) {    
    Navigator.of(context).push(MaterialPageRoute<ReceiptScreen>(
      fullscreenDialog: true,
      builder: (_) => ReceiptScreen(transactionResource: _transactionResource)
    ));
  }
}