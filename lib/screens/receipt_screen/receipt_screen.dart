import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../../global_widgets/purchased_item_widget.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionResource _transactionResource;

  ReceiptScreen({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          BottomModalAppBar(
            context: context,
            isSliver: true,
            trailingWidgets: [],
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: _buildBody(context: context)
              ),
            ),
          )
        ],
      )
    );
  }

  List<Widget> _buildBody({required BuildContext context}) {
    return <Widget> [
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            Hero(
              tag: _transactionResource.transaction.identifier, 
              child: CircleAvatar(
                backgroundImage: NetworkImage(_transactionResource.customer.photo.largeUrl),
                radius: SizeConfig.getWidth(5),
              )
            ),
            SizedBox(width: SizeConfig.getWidth(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldText5(
                    text: "${_transactionResource.customer.firstName} ${_transactionResource.customer.lastName}",
                    context: context,
                  ),
                  Text5(
                    text: DateFormatter.toStringDateTime(date: _transactionResource.transaction.updatedAt),
                    context: context,
                    color: Theme.of(context).colorScheme.onPrimarySubdued
                  )
                ],
              )
            ),
          ],
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(3)),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) => PurchasedItemWidget(purchasedItem: _transactionResource.purchasedItems[index]),
        itemCount: _transactionResource.purchasedItems.length,
        separatorBuilder: (_, __) => Divider(thickness: 1),
      ),
      Divider(thickness: 1),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(height:SizeConfig.getHeight(3)),
            _footerRow(context: context, title: "Subtotal", value: _transactionResource.transaction.netSales),
            SizedBox(height:SizeConfig.getHeight(1)),
            _footerRow(context: context, title: "Tax", value: _transactionResource.transaction.tax),
            if (_transactionResource.transaction.tip != 0)
              SizedBox(height:SizeConfig.getHeight(1)),
            if (_transactionResource.transaction.tip != 0)
              _footerRow(context: context, title: "Tip", value: _transactionResource.transaction.tip),
            if (_transactionResource.refunds.length > 0)
              SizedBox(height: SizeConfig.getHeight(1)),
            if (_transactionResource.refunds.length > 0)
              _refundRow(context: context),
            SizedBox(height:SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoldText4(text: "Total", context: context),
                BoldText4(text: Currency.create(cents: _setTotal()), context: context),
              ],
            )
          ],
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(2)),
      Divider(thickness: 2),
      SizedBox(height: SizeConfig.getHeight(2)),
      Center(
        child: Text5(
          text: "Transaction ID: ${_transactionResource.transaction.identifier}",
          context: context,
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(2)),
    ];
  }

  Widget _footerRow({required BuildContext context, required String title, required int value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text4(
          text: title, 
          context: context, 
        ),
        Text4(
          text: Currency.create(cents: value), 
          context: context,
        )
      ],
    );
  }

  Widget _refundRow({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text2(
          text: "Total Refund", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
        Text2(
          text: "(${Currency.create(cents: _transactionResource.refunds.fold(0, (total, refund) => total + refund.total))})", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
      ],
    );
  }

  int _setTotal() {
    return _transactionResource.refunds.length > 0
      ? _transactionResource.transaction.total - _transactionResource.refunds.fold(0, (total, refund) => total + refund.total)
      : _transactionResource.transaction.total;
  }
}