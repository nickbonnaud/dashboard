import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/purchased_item_widget.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';

class ReceiptScreenUnassigned extends StatelessWidget {
  final UnassignedTransaction _unassignedTransaction;

  const ReceiptScreenUnassigned({required UnassignedTransaction unassignedTransaction})
    : _unassignedTransaction = unassignedTransaction;

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
                children: _body(context: context)
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _body({required BuildContext context}) {
    return <Widget> [
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(
                Icons.person,
                size: FontSizeAdapter.setSize(size: 6, context: context),
              ),
              radius: FontSizeAdapter.setSize(size: 5, context: context),
            ),
            SizedBox(width: SizeConfig.getWidth(4)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldText5(
                    text: "No Assigned Customer",
                    context: context,
                  ),
                  Text5(
                    text: DateFormatter.toStringDateTime(date: _unassignedTransaction.transaction.createdAt),
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
        itemBuilder: (_, index) => PurchasedItemWidget(purchasedItem: _unassignedTransaction.transaction.purchasedItems[index]),
        itemCount: _unassignedTransaction.transaction.purchasedItems.length,
        separatorBuilder: (_, __) => Divider(thickness: 1),
      ),
      Divider(thickness: 1),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(height: SizeConfig.getHeight(3)),
            _footerRow(context: context, title: "Subtotal", value: _unassignedTransaction.transaction.netSales),
            SizedBox(height: SizeConfig.getHeight(1)),
            _footerRow(context: context, title: "Tax", value: _unassignedTransaction.transaction.tax),
            SizedBox(height: SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoldText4(text: "Total", context: context),
                BoldText4(text: Currency.create(cents: _unassignedTransaction.transaction.total), context: context),
              ],
            ),
            if (_unassignedTransaction.employee != null)
              SizedBox(height: SizeConfig.getHeight(3)),
            if (_unassignedTransaction.employee != null)
              Divider(),
            if (_unassignedTransaction.employee != null)
              Center(
                child: Text4(
                  text: "Employee: ${_unassignedTransaction.employee!.firstName} ${_unassignedTransaction.employee!.lastName}", 
                  context: context
                ),
              )
          ],
        ),
      ),
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
}