import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_row_column.dart';

import 'widgets/net_sales_today.dart';
import 'widgets/total_refunds_today.dart';
import 'widgets/total_sales_today.dart';
import 'widgets/total_tips_today.dart';

class Today extends StatelessWidget {
  final ResponsiveLayoutHelper _layoutHelper = ResponsiveLayoutHelper();
  final bool _takesTips;

  Today({required bool takesTips, Key? key})
    : _takesTips = takesTips,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            BoldText5(text: 'Today', context: context),
            SizedBox(height: SizeConfig.getHeight(2)),
            _topToday(context: context),
            _bottomToday(context: context)
          ],
        ),
      ),
    );
  }

  Widget _topToday({required BuildContext context}) {
    return ResponsiveRowColumn(
      layout: _layoutHelper.setLayout(context: context),
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      columnMainAxisSize: MainAxisSize.min,
      columnSpacing: SizeConfig.getHeight(2),
      rowSpacing: SizeConfig.getWidth(1),
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: NetSalesToday()
        ),
        const ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalRefundsToday(),
        )
      ],
    );
  }

  Widget _bottomToday({required BuildContext context}) {
    return _takesTips
      ? _takesTipsBottom(context: context)
      : const TotalSalesToday();
  }

  Widget _takesTipsBottom({required BuildContext context}) {
    return ResponsiveRowColumn(
      layout: _layoutHelper.setLayout(context: context),
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      columnMainAxisSize: MainAxisSize.min,
      columnSpacing: SizeConfig.getHeight(2),
      rowSpacing: SizeConfig.getWidth(1),
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalTipsToday()
        ),
        const ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: TotalSalesToday(),
        )
      ],
    );
  }
}