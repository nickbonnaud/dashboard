import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/receipt_screen/receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class RefundWidget extends StatelessWidget {
  final RefundResource _refundResource;
  final int _index;

  const RefundWidget({required RefundResource refundResource, required int index})
    : _refundResource = refundResource,
      _index = index;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("refund-$_index"),
      child: ListTile(
        leading: Hero(
          tag: _refundResource.refund.identifier,
          child: CircleAvatar(
            backgroundImage: NetworkImage(_refundResource.transactionResource.customer.photo.largeUrl),
            backgroundColor: Colors.transparent,
          )
        ),
        title: Text4(
          text: "${_refundResource.transactionResource.customer.firstName} ${_refundResource.transactionResource.customer.lastName}", 
          context: context
        ),
        subtitle: Text5(
          text: "Refund: ${Currency.create(cents: _refundResource.refund.total)}",
          context: context
        ),
        trailing: Text5(
          text: DateFormatter.toStringDateTime(date: _refundResource.refund.createdAt),
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
      builder: (context) => ReceiptScreen(transactionResource: _refundResource.transactionResource)
    ));
  }
}