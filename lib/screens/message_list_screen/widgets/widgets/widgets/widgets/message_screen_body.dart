import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../bloc/message_history_bloc.dart';
import 'widgets/message_history/helpers/text_sizer.dart';
import 'widgets/message_history/message_history.dart';
import 'widgets/message_input/bloc/message_input_bloc.dart';
import 'widgets/message_input/message_input.dart';


class MessageScreenBody extends StatelessWidget {
  final MessageRepository _messageRepository;

  const MessageScreenBody({required MessageRepository messageRepository, Key? key})
    : _messageRepository = messageRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
        ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
        : EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(10), vertical: SizeConfig.getHeight(2)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            color: Colors.white,
            child: Column(
              children: [
                MessageHistory(
                  constraints: constraints,
                  textSizer: TextSizer(context: context),
                ),
                BlocProvider<MessageInputBloc>(
                  create: (context) => MessageInputBloc(
                    messageRepository: _messageRepository,
                    messageHistoryBloc: BlocProvider.of<MessageHistoryBloc>(context)
                  ),
                  child: const MessageInput(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}