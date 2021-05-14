import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';

import 'widgets/net_sales_month.dart';
import 'widgets/total_refunds_month.dart';
import 'widgets/total_sales_month.dart';
import 'widgets/total_taxes_month.dart';
import 'widgets/total_tips_month.dart';
import 'widgets/total_transactions_month.dart';
import 'widgets/total_unique_customers_month.dart';

class LastMonth extends StatelessWidget {
    
  final List<Widget> monthData = [
    NetSalesMonth(),
    TotalTaxesMonth(),
    TotalTipsMonth(),
    TotalSalesMonth(),
    TotalRefundsMonth(),
    TotalUniqueCustomersMonth(),
    TotalTransactionsMonth()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: BoldText5(text: 'Last 30 Days', context: context),
          ),
          SizedBox(height: SizeConfig.getHeight(2)),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: monthData.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return monthData[index];
            },
          ),
        ],
      ),
    );
  }
}