import 'package:dashboard/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/filter_button_bloc.dart';
import 'cubit/date_range_cubit.dart';
import 'widgets/customers_screen_body.dart';

class CustomersScreen extends StatefulWidget {
  final CustomerRepository _customerRepository;

  const CustomersScreen({required CustomerRepository customerRepository})
    : _customerRepository = customerRepository;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> with AutomaticKeepAliveClientMixin<CustomersScreen> {

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FilterButtonBloc>(
            create: (_) => FilterButtonBloc()
          ),
          BlocProvider<DateRangeCubit>(
            create: (_) => DateRangeCubit()
          )
        ],
        child: CustomersScreenBody(customerRepository: widget._customerRepository),
      ),
    );
  }
}