import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/menu_button.dart';
import 'widgets/message_button.dart';


class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool _isSliver;
  final List<Widget> _trailingWidgets;

  const DefaultAppBar({
    required BuildContext context,
    bool isSliver = false,
    List<Widget> trailingWidgets = const [],
    Key? key
  })
    : _isSliver = isSliver,
      _trailingWidgets = trailingWidgets,
      super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    if (_isSliver) {
      return _sliverAppBar(context: context);
    }
    return _appBar(context: context);
  }

  SliverAppBar _sliverAppBar({required BuildContext context}) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      backgroundColor: Colors.grey.shade200,
      actions: _actions(),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.callToAction)
    );
  }

  AppBar _appBar({required BuildContext context}) {
    return AppBar(
      title: _title(context: context),
      centerTitle: true,
      backgroundColor: Colors.grey.shade200,
      actions: _actions(),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.callToAction)
    );
  }

  List<Widget> _actions() {
    if (_trailingWidgets.isEmpty) return [const MessageButton(), const MenuButton()];
    return _trailingWidgets;
  }

  Widget _title({required BuildContext context}) {
    return SizedBox(
      height: kToolbarHeight - 20,
      child: Image(
        fit: BoxFit.contain,
        image: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? const AssetImage('assets/icon.png')
          : const AssetImage('assets/logo.png')
      ),
    );
  }
}