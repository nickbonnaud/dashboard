import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/pos_account.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/repositories/refund_repository.dart';
import 'package:dashboard/repositories/tips_repository.dart';
import 'package:dashboard/repositories/transaction_repository.dart';
import 'package:dashboard/repositories/unassigned_transaction_repository.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/account_menu_screen/account_menu_screen.dart';
import 'package:dashboard/screens/customers_screen/customers_screen.dart';
import 'package:dashboard/screens/historic_refunds_screen/historic_refunds_screen.dart';
import 'package:dashboard/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:dashboard/screens/quick_dashboard_screen/quick_dashboard_screen.dart';
import 'package:dashboard/screens/sales_screen/sales_screen.dart';
import 'package:dashboard/screens/tips_screen/tips_screen.dart';
import 'package:dashboard/screens/unassigned_transactions_screen/unassigned_transactions_screen.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../cubit/home_screen_cubit.dart';
import 'models/app_tab.dart';

class HomeScreenBody extends StatefulWidget {
  final TransactionRepository _transactionRepository;
  final RefundRepository _refundRepository;
  final TipsRepository _tipsRepository;
  final UnassignedTransactionRepository _unassignedTransactionRepository;
  final CustomerRepository _customerRepository;
  final PosAccount _posAccount;

  const HomeScreenBody({
    required TransactionRepository transactionRepository,
    required RefundRepository refundRepository,
    required TipsRepository tipsRepository,
    required UnassignedTransactionRepository unassignedTransactionRepository,
    required CustomerRepository customerRepository,
    required PosAccount posAccount,
    Key? key
  })
    : _transactionRepository = transactionRepository,
      _refundRepository = refundRepository,
      _tipsRepository = tipsRepository,
      _unassignedTransactionRepository = unassignedTransactionRepository,
      _customerRepository = customerRepository,
      _posAccount = posAccount,
      super(key: key);

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
          transactionRepository: widget._transactionRepository,
          refundRepository: widget._refundRepository,
          takesTips: widget._posAccount.takesTips,
        ), 
        title: "Home", 
        icon: Icons.home
      ),
      AppTab(
        child: HistoricTransactionsScreen(
          transactionRepository: widget._transactionRepository
        ),
        title: "Transactions", 
        icon: Icons.receipt
      ),
      AppTab(
        child: HistoricRefundsScreen(
          refundRepository: widget._refundRepository
        ),
        title: "Refunds",
        icon: Icons.receipt_long
      ),
      AppTab(
        child: TipsScreen(
          tipsRepository: widget._tipsRepository,
          transactionRepository: widget._transactionRepository,
        ), 
        title: "Tips Center",
        icon: Icons.volunteer_activism
      ),
      AppTab(
        child: SalesScreen(
          transactionRepository: widget._transactionRepository,
        ), 
        title: "Sales Center",
        icon: Icons.payments
      ),
      AppTab(
        child: UnassignedTransactionsScreen(
          unassignedTransactionRepository: widget._unassignedTransactionRepository,
          posAccount: widget._posAccount,
        ),
        title: "Unmatched Bills",
        icon: Icons.person_search
      ),
      AppTab(
        child: CustomersScreen(
          customerRepository: widget._customerRepository
        ),
        title: "Customers",
        icon: Icons.person_pin
      ),
      AppTab(
        child: const AccountMenuScreen(),
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
      drawer: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
        ? Padding(
            padding: const EdgeInsets.only(top: 56),
            child: Drawer(
              key: const Key("menuDrawerKey"),
              child: _drawerItems(drawerOpen: true),
            ),
          )
        : null
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
          margin: const EdgeInsets.all(0),
          height: MediaQuery.of(context).size.height,
          width: 300,
          color: Colors.white,
          child: _drawerItems(drawerOpen: false),
        ),
      );
  }

  Widget _body() {
    return SizedBox(
      width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width - 310,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
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
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(
                    tab.icon,
                    color: Theme.of(context).colorScheme.callToAction,
                    size: FontSizeAdapter.setSize(size: 3, context: context),
                  ),
                  SizedBox(width: SizeConfig.getWidth(1)),
                  Text5(
                    text: tab.title,
                    color: Theme.of(context).colorScheme.callToAction,
                    context: context,
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