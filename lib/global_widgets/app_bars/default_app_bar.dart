import 'package:dashboard/models/business/profile.dart';
import 'package:flutter/material.dart';

import 'widgets/menu_button.dart';
import 'widgets/message_button.dart';


class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final List<Widget> _trailingWidgets;

  DefaultAppBar({required BuildContext context, bool isSliver = false, List<Widget> trailingWidgets = const [], Color? backgroundColor})
    : _backgroundColor = backgroundColor == null
        ? Theme.of(context).colorScheme.secondary
        : backgroundColor,
      _isSliver = isSliver,
      _trailingWidgets = trailingWidgets;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
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
      backgroundColor: _backgroundColor,
      actions: _actions(),
    );
  }

  AppBar _appBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: _backgroundColor,
      actions: _actions()
    );
  }

  List<Widget> _actions() {
    if (_trailingWidgets.isEmpty) return [MessageButton(),  MenuButton()];
    return _trailingWidgets;
  }
}