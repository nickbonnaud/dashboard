import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/purchased_item_widget.dart';
import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:dashboard/extensions/string_extensions.dart';

class ReceiptScreen extends StatelessWidget {
  final CustomerResource _customerResource;

  const ReceiptScreen({required CustomerResource customerResource})
    : _customerResource = customerResource;

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
      ),
    );
  }

  List<Widget> _buildBody({required BuildContext context}) {
    return <Widget> [
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Hero(
                  tag: _customerResource.customer.identifier,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_customerResource.customer.photo.largeUrl),
                    radius: SizeConfig.getWidth(5),
                  )
                ),
                SizedBox(width: SizeConfig.getWidth(4)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldText5(
                      text: "${_customerResource.customer.firstName} ${_customerResource.customer.lastName}",
                      context: context,
                    ),
                    Text5(
                      text: DateFormatter.toStringDateTime(date: _customerResource.transaction!.updatedAt),
                      context: context,
                      color: Theme.of(context).colorScheme.onPrimarySubdued
                    )
                  ],
                ),
              ],
            ),
            Text5(
              text: "${_customerResource.transaction!.status.name.capitalizeFirstEach}",
              context: context,
            ),
          ],
        ),
      ),
      SizedBox(height: SizeConfig.getHeight(3)),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) => PurchasedItemWidget(purchasedItem: _customerResource.transaction!.purchasedItems[index]),
        itemCount: _customerResource.transaction!.purchasedItems.length,
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
            _footerRow(context: context, title: "Subtotal", value: _customerResource.transaction!.netSales),
            SizedBox(height:SizeConfig.getHeight(1)),
            _footerRow(context: context, title: "Tax", value: _customerResource.transaction!.tax),
            if (_customerResource.transaction!.tip != 0)
              SizedBox(height:SizeConfig.getHeight(1)),
            if (_customerResource.transaction!.tip != 0)
              _footerRow(context: context, title: "Tip", value: _customerResource.transaction!.tip),
            if (_customerResource.transaction!.refunds.length > 0)
              SizedBox(height: SizeConfig.getHeight(1)),
            if (_customerResource.transaction!.refunds.length > 0)
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
      Divider(thickness: 2),
      Center(
        child: Text5(
          text: "Transaction ID: ${_customerResource.transaction!.identifier}",
          context: context,
          color: Theme.of(context).colorScheme.onPrimarySubdued
        ),
      ),
      Divider(thickness: 2),
      Center(
        child: _customerResource.notification != null
          ? Text5(
              text: "Last Notification: ${_customerResource.notification!.lastNotification} at ${DateFormatter.toStringDateTime(date: _customerResource.notification!.updatedAt)}",
              context: context,
              color: Theme.of(context).colorScheme.onPrimarySubdued
            )
          : Container()
      ),
      SizedBox(height: SizeConfig.getHeight(1))
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
        Text4(
          text: "Total Refund", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
        Text4(
          text: "(${Currency.create(cents: _customerResource.transaction!.refunds.fold(0, (total, refund) => total + refund.total))})", 
          context: context, 
          color: Theme.of(context).colorScheme.info
        ),
      ],
    );
  }

  int _setTotal() {
    return _customerResource.transaction!.refunds.length > 0
      ? _customerResource.transaction!.total - _customerResource.transaction!.refunds.fold(0, (total, refund) => total + refund.total)
      : _customerResource.transaction!.total;
  }
}