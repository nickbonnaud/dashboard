import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/last_month/last_month.dart';
import 'widgets/recent_transactions/recent_transactions.dart';
import 'widgets/today/today.dart';

class QuickDashboardBody extends StatelessWidget {
  final ResponsiveLayoutHelper _layoutHelper = const ResponsiveLayoutHelper();

  const QuickDashboardBody({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(3)),
          ResponsiveRowColumn(
            layout: _layoutHelper.setLayout(context: context, deviceSize: TABLET),
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            columnSpacing: SizeConfig.getHeight(3),
            rowSpacing: SizeConfig.getWidth(3),
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                rowFit: FlexFit.tight,
                child: _recentDataRowColumn(context: context)
              ),
              const ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: LastMonth()
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _recentDataRowColumn({required BuildContext context}) {
    return Column(
      children: [
        const Today(),
        SizedBox(height: SizeConfig.getHeight(3)),
        const RecentTransactions()
      ],
    );
  }
}