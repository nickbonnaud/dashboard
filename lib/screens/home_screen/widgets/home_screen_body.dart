import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/providers/customer_provider.dart';
import 'package:dashboard/providers/refund_provider.dart';
import 'package:dashboard/providers/transaction_provider.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/screens/account_menu_screen/account_menu_screen.dart';
import 'package:dashboard/screens/customers_screen/customers_screen.dart';
import 'package:dashboard/screens/historic_refunds_screen/historic_refunds_screen.dart';
import 'package:dashboard/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:dashboard/screens/quick_dashboard_screen/quick_dashboard_screen.dart';
import 'package:dashboard/screens/sales_screen/sales_screen.dart';
import 'package:dashboard/screens/tips_screen/tips_screen.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/unassigned_transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'models/app_tab.dart';
import '../cubit/home_screen_cubit.dart';

class HomeScreenBody extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late List<AppTab> _tabs;
  
  @override
  void initState() {
    super.initState();
    _tabs = [
      AppTab(
        child: QuickDashboardScreen(
          transactionRepository: TransactionRepository(transactionProvider: TransactionProvider()),
          refundRepository: RefundRepository(refundProvider: RefundProvider()),
          takesTips: BlocProvider.of<BusinessBloc>(context).business.posAccount.takesTips,
        ), 
        title: "Home", 
        icon: Icons.home
      ),
      AppTab(
        child: HistoricTransactionsScreen(
          transactionRepository: TransactionRepository(transactionProvider: TransactionProvider())
        ),
        title: "Transactions", 
        icon: Icons.receipt
      ),
      AppTab(
        child: HistoricRefundsScreen(
          refundRepository: RefundRepository(refundProvider: RefundProvider())
        ),
        title: "Refunds",
        icon: Icons.receipt_long
      ),
      AppTab(
        child: TipsScreen(), 
        title: "Tips Center",
        icon: Icons.volunteer_activism
      ),
      AppTab(
        child: SalesScreen(), 
        title: "Sales Center",
        icon: Icons.payments
      ),
      AppTab(
        child: UnassignedTransactionsScreen(),
        title: "Unassigned Transactions",
        icon: Icons.person_search
      ),
      AppTab(
        child: CustomersScreen(
          customerRepository: CustomerRepository(customerProvider: CustomerProvider())
        ),
        title: "Customers",
        icon: Icons.person_pin
      ),
      AppTab(
        child: AccountMenuScreen(),
        title: "Account",
        icon: Icons.business
      )
    ];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context),
      body: Row(
        children: [
          _drawer(),
          _body()
        ],
      ),
      drawer: Padding(
        padding: EdgeInsets.only(top: 56),
        child: Drawer(
          child: _drawerItems(drawerOpen: true),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _drawer() {
    return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) 
      ? Container()
      : Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(0),
          height: MediaQuery.of(context).size.height,
          width: 300,
          color: Colors.white,
          child: _drawerItems(drawerOpen: false),
        ),
      );
  }

  Widget _body() {
    return Container(
      width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width - 310,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabs.map((tab) => tab.child).toList()
      ),
    );
  }

  Widget _drawerItems({required bool drawerOpen}) {
    return ListView(
      children: List.generate(
        _tabs.length,
        (index) => _drawerItem(
          drawerIndex: index,
          drawerOpen: drawerOpen,
          tab: _tabs[index]
        )
      )
    );
  }

  Widget _drawerItem({required int drawerIndex, required bool drawerOpen, required AppTab tab}) {
    return BlocBuilder<HomeScreenCubit, int>(
      builder: (context, currentTab) {
        return TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              currentTab == drawerIndex
                ? Colors.grey[100]!
                : Colors.white,
            )
          ),
          onPressed: () {
            _tabController.animateTo(drawerIndex);
            if (drawerOpen) {
              Navigator.of(context).pop();
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(22),
              child: Row(
                children: [
                  Icon(tab.icon, color: Theme.of(context).colorScheme.callToAction),
                  SizedBox(width: 8),
                  Text(
                    tab.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.callToAction
                    ),
                    
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }

  void _onTabChanged() {
    context.read<HomeScreenCubit>().tabChanged(currentTab: _tabController.index);
  }
}