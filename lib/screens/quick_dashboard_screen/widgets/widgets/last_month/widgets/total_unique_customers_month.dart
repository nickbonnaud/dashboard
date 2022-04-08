import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_unique_customers_month_bloc/total_unique_customers_month_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

class TotalUniqueCustomersMonth extends StatelessWidget {

  const TotalUniqueCustomersMonth({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Unique Customers'),
      trailing: BlocBuilder<TotalUniqueCustomersMonthBloc, TotalUniqueCustomersMonthState>(
        builder: (context, state) {
          if (state is TotalUniqueCustomersInitial || state is Loading) return CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction);
          if (state is FetchTotalUniqueCustomersFailed) return _error(context: context);

          return Text4(text: (state as TotalUniqueCustomersLoaded).totalUniqueCustomers.toString(), context: context);
        }
      ),
    );
  }

  Widget _error({required BuildContext context}) {
    return Icon(
      Icons.warning,
      color: Theme.of(context).colorScheme.danger,
    );
  }
}