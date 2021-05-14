import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/today/net_sales_today_bloc/net_sales_today_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NetSalesToday extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(22),
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
            BlocBuilder<NetSalesTodayBloc, NetSalesTodayState>(
              builder: (context, state) {
                if (state is Loading || state is NetSalesInitial) return CircularProgressIndicator(key: Key("netSalesTodayCircularProgressKey"));
                if (state is FetchFailed) return _error();

                return _amount(netSales: (state as NetSalesLoaded).netSales);
              }
            )
          ],
        )
      ),
    );
  }

  Widget _amount({required int netSales}) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: FittedBox(
          child: Text(
            Currency.create(cents: netSales),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
  
  Widget _error() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: FittedBox(
          child: Text(
            "Error Loading!",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
}