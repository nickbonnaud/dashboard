import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class PurchasedItemWidget extends StatelessWidget {
  final PurchasedItem _purchasedItem;

  PurchasedItemWidget({required PurchasedItem purchasedItem})
    : _purchasedItem = purchasedItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text4(
        text: _purchasedItem.quantity.toString(),
        context: context,
      ),
      title: Text4(
        text: _purchasedItem.name,
        context: context
      ),
      subtitle: _purchasedItem.subName != null
        ? Text5(
            text: _purchasedItem.subName as String,
            context: context,
            color: Theme.of(context).colorScheme.onPrimarySubdued,
          )
        : null,
      trailing: Text4(
        text: Currency.create(cents: _purchasedItem.total),
        context: context
      ),
    );
  }
}