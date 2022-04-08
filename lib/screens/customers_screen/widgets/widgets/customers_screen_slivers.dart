import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'widgets/customers_list.dart';
import 'widgets/date_display.dart';
import 'widgets/search_display.dart';

class CustomersScreenSlivers extends StatefulWidget {
  
  const CustomersScreenSlivers({Key? key})
    : super(key: key);

  @override
  State<CustomersScreenSlivers> createState() => _CustomersScreenSliversState();
}

class _CustomersScreenSliversState extends State<CustomersScreenSlivers> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _searchDisplay(),
        _dateDisplay(),
        _customersList()
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _searchDisplay() {
    return SliverPadding(
      padding: _padding(),
      sliver: const SearchDisplay(),
    );
  }

  Widget _dateDisplay() {
    return SliverPadding(
      padding: _padding(),
      sliver: const SliverToBoxAdapter(
        child: DateDisplay(),
      ),
    );
  }

  Widget _customersList() {
    return SliverPadding(
      padding: _padding(),
      sliver: CustomersList(
        scrollController: _scrollController
      ),
    );
  }

  EdgeInsetsGeometry _padding() {
    return ResponsiveWrapper.of(context).isSmallerThan(TABLET) 
      ? EdgeInsets.only(left: SizeConfig.getWidth(10), right: SizeConfig.getWidth(10))
      : EdgeInsets.only(left: SizeConfig.getWidth(15), right: SizeConfig.getWidth(15));
  }
}