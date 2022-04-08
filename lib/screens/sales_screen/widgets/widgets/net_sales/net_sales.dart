import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/widgets/amount.dart';
import 'package:dashboard/screens/sales_screen/widgets/widgets/widgets/fetch_fail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/net_sales_bloc.dart';

class NetSales extends StatelessWidget {

  const NetSales({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(22),
        color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.credit_card,
                  size: FontSizeAdapter.setSize(size: 4, context: context),
                  color: Colors.white,
                ),
                Text5(text: 'Net Sales', context: context, color: Colors.white)
              ],
            ),
            BlocBuilder<NetSalesBloc, NetSalesState>(
              builder: (context, state) {
                if (state is Loading || state is NetSalesInitial) return const CircularProgressIndicator();
                if (state is FetchFailed) return const FetchFailWidget();
                
                return Amount(total: (state as NetSalesLoaded).netSales);
              }
            )
          ],
        ),
      ),
    );
  }
}