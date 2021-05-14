import 'package:dashboard/blocs/messages/messages_bloc.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.getWidth(3)),
      child: BlocBuilder<MessagesBloc, MessagesState>(
        builder: (context, state) {
          if (state.hasUnreadMessages) return _unreadMessagesButton(context: context);
          
          return _noUnreadMessagesButton(context: context);
        }
      ),
    );
  }

  Widget _unreadMessagesButton({required BuildContext context}) {
    return IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.notifications,
            size: FontSizeAdapter.setSize(size: 3.5, context: context),
          ),
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.all(3)
                  )
                ),
                Icon(
                  Icons.error_outlined,
                  color: Theme.of(context).colorScheme.warning,
                  size: FontSizeAdapter.setSize(size: 2, context: context),
                )
              ],
            ),
          )
        ],
      ),
      onPressed: () => _showMessageListScreen(context: context)
    );
  }
  
  Widget _noUnreadMessagesButton({required BuildContext context}) {
    return IconButton(
      icon: Icon(
        Icons.notifications,
        size: FontSizeAdapter.setSize(size: 3.5, context: context),
      ),
      onPressed: () => _showMessageListScreen(context: context)
    );
  }

  void _showMessageListScreen({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.messages);
  }
}