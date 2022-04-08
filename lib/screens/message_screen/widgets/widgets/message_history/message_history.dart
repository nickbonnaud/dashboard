import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:dashboard/screens/message_screen/widgets/widgets/message_history/helpers/text_sizer.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'widgets/message_bubble.dart';


class MessageHistory extends StatelessWidget {
  final BoxConstraints _constraints;
  final TextSizer _textSizer;

  const MessageHistory({required BoxConstraints constraints, required TextSizer textSizer, Key? key})
    : _constraints = constraints,
      _textSizer = textSizer,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<MessageHistoryBloc, MessageHistoryState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: state.message.replies.length + 1,
            reverse: true,
            itemBuilder: (context, index) {
              if (index == state.message.replies.length) return _initialMessage(context: context, state: state);
              return MessageBubble(
                index: index,
                reply: state.message.replies[index],
                textSizer: _textSizer,
                constraints: _constraints,
              );
            }
          );
        }
      )
    );
  }

  Widget _initialMessage({required BuildContext context, required MessageHistoryState state}) {
    return state.message.fromBusiness
      ? _fromBusiness(context: context, message: state.message)
      : _fromAdmin(context: context, message: state.message);
  }

  Widget _fromBusiness({required BuildContext context, required Message message}) {
    return Container(
      key: const Key("initialMessage"),
      margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      message.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onCallToAction,
                        fontSize: _textSizer.set(size: 3, maxWidth: _constraints.maxWidth)
                      ),
                    ),

                    Text(
                      message.body,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onCallToAction,
                        fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                      ),
                    )
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: _bubbleWidth(context: context),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.callToAction,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: const EdgeInsets.only(right: 10.0),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: _dateWidth(context: context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        DateFormatter.toStringDate(date: message.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    ),

                    if (message.read)
                      Container(
                        padding: const EdgeInsets.only(right: 15.0, top: 5.0, bottom: 5.0),
                        child: Text(
                          "Read",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryDisabled,
                            fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                          ),
                        )
                      )
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _fromAdmin({required BuildContext context, required Message message}) {
    return Container(
      key: const Key("initialMessage"),
      margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      message.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: _textSizer.set(size: 3, maxWidth: _constraints.maxWidth)
                      ),
                    ),
                    Text(
                      message.body,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: _bubbleWidth(context: context),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.callToActionDisabled,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: const EdgeInsets.only(left: 10.0),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: _dateWidth(context: context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        DateFormatter.toStringDate(date: message.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 5.0),
                  ),

                  if (message.read)
                    SizedBox(
                      child: Text(
                        'Read',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryDisabled,
                          fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ) 
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  double _bubbleWidth({required BuildContext context}) {
    return ResponsiveWrapper.of(context).isSmallerThan(TABLET)
      ? _textSizer.width(size: 30, maxWidth: _constraints.maxWidth)
      : _textSizer.width(size: 25, maxWidth: _constraints.maxWidth);
  }

  double _dateWidth({required BuildContext context}) {
    return ResponsiveWrapper.of(context).isSmallerThan(TABLET)
      ? _textSizer.width(size: 32, maxWidth: _constraints.maxWidth)
      : _textSizer.width(size: 27, maxWidth: _constraints.maxWidth);
  }
}