import 'dart:math';

import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/menu_button.dart';
import 'widgets/message_button.dart';

class BottomModalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color _backgroundColor;
  final bool _isSliver;
  final List<Widget> _trailingWidgets;
  final String _title;

  BottomModalAppBar({required BuildContext context, bool isSliver = false, List<Widget> trailingWidgets = const [], String title = "", Color? backgroundColor})
    : _backgroundColor = backgroundColor == null 
        ? Theme.of(context).colorScheme.secondary
        : backgroundColor,
      _isSliver = isSliver,
      _trailingWidgets = trailingWidgets,
      _title = title;
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<BottomModalAppBar> createState() => _BottomModalAppBarState();
}

class _BottomModalAppBarState extends State<BottomModalAppBar> with TickerProviderStateMixin {
  late Animation _showAnimation;
  late AnimationController _showAnimationController;
  
  @override
  void initState() {
    super.initState();
    _showAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _showAnimation = Tween(begin: pi / 2, end: 0.0).animate(_showAnimationController);
    _showAnimationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget._isSliver) {
      return _sliverAppBar();
    }
    return _defaultAppBar();
  }

  SliverAppBar _sliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      elevation: 0,
      backgroundColor: widget._backgroundColor,
      actions: _actions(),
      leading: _builder(context: context),
    );
  }

  AppBar _defaultAppBar() {
    return AppBar(
      title: widget._title.isNotEmpty ? BoldText2(text: widget._title, context: context) : null,
      elevation: 0,
      backgroundColor: widget._backgroundColor,
      actions: _actions(),
      leading: _builder(context: context)
    );
  }

  AnimatedBuilder _builder({required BuildContext context}) {
    return AnimatedBuilder(
      animation: _showAnimationController, 
      builder: (context, child) => Transform.rotate(
        angle: _showAnimation.value,
        child: IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: FontSizeAdapter.setSize(size: 4, context: context),
        ),
      )
    );
  }

  @override
  void dispose() {
    _showAnimationController.dispose();
    super.dispose();
  }

  List<Widget> _actions() {
    if (widget._trailingWidgets.isEmpty) return [MessageButton(),  MenuButton()];
    return widget._trailingWidgets;
  }
}