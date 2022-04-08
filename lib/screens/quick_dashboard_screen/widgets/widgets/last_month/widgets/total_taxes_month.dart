import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/quick_dashboard_screen/blocs/last_month/total_taxes_month_bloc/total_taxes_month_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';


class TotalTaxesMonth extends StatelessWidget {

  const TotalTaxesMonth({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Taxes'),
      trailing: BlocBuilder<TotalTaxesMonthBloc, TotalTaxesMonthState>(
        builder: (context, state) {
          if (state is TotalTaxesInitial || state is Loading) return CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction);
          if (state is FetchTotalTaxesFailed) return _error(context: context);

          return Text4(text: Currency.create(cents: (state as TotalTaxesLoaded).totalTaxes), context: context);
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