import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'receipt_screen.dart';

class CustomerWidget extends StatelessWidget {
  final int _index;
  final CustomerResource _customerResource;

  const CustomerWidget({required int index, required CustomerResource customerResource, Key? key})
    : _index = index,
      _customerResource = customerResource,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("customer-$_index"),
      child: ListTile(
        leading: Hero(
          tag: _customerResource.customer.identifier,
          child: CircleAvatar(
            backgroundImage: NetworkImage(_customerResource.customer.photo.largeUrl),
            backgroundColor: Colors.transparent,
          )
        ),
        title: Text4(
          text: "${_customerResource.customer.firstName} ${_customerResource.customer.lastName}", 
          context: context
        ),
        subtitle: _customerResource.transaction != null
          ? Text5(text: "Total: ${Currency.create(cents: _customerResource.transaction!.total)}", context: context)
          : null,
        trailing: Text5(
          text: DateFormatter.toStringDateTime(date: _customerResource.enteredAt),
          context: context,
          color: Theme.of(context).colorScheme.onPrimarySubdued,
        ),
        onTap: _customerResource.transaction != null
         ? () => _showTransaction(context: context)
         : null,
      ),
    );
  }

  void _showTransaction({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute<ReceiptScreen>(
      fullscreenDialog: true,
      builder: (_) => ReceiptScreen(customerResource: _customerResource)
    ));
  }
}