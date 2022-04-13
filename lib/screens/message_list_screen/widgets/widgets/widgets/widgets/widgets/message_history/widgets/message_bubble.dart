import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/resources/helpers/date_formatter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../helpers/text_sizer.dart';

class MessageBubble extends StatelessWidget {
  final int _index;
  final Reply _reply;
  final TextSizer _textSizer;
  final BoxConstraints _constraints;

  const MessageBubble({
    required int index,
    required Reply reply,
    required TextSizer textSizer,
    required BoxConstraints constraints,
    Key? key
  })
    : _index = index,
      _reply = reply,
      _textSizer = textSizer,
      _constraints = constraints,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return _reply.fromBusiness
      ? _fromBusinessBubble(context: context)
      : _fromAdminBubble(context: context); 
  }

  Widget _fromBusinessBubble({required BuildContext context}) {
    return Container(
      key: Key("bubble-$_index"),
      margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  _reply.body,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onCallToAction,
                    fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                  ),
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
                        DateFormatter.toStringDate(date: _reply.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    ),

                    if (_reply.read)
                      Container(
                        padding: const EdgeInsets.only(right: 8.0, top: 5.0, bottom: 5.0),
                        child: Text(
                          "Read",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryDisabled,
                            fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                          ),
                        ),
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

  Widget _fromAdminBubble({required BuildContext context}) {
    return Container(
      key: Key("bubble-$_index"),
      margin: EdgeInsets.only(bottom: SizeConfig.getHeight(5)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  _reply.body,
                  style: TextStyle(
                    fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                  ),
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
                        DateFormatter.toStringDate(date: _reply.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: _textSizer.set(size: 2, maxWidth: _constraints.maxWidth)
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 5.0),
                  ),

                  if (_reply.read)
                    SizedBox(
                      child: Text(
                        "Read",
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