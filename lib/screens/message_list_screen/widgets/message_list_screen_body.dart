import 'package:dashboard/global_widgets/bottom_loader.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'widgets/message_widget.dart';
import '../bloc/message_list_screen_bloc.dart';

class MessageListScreenBody extends StatefulWidget {
  final MessageRepository _messageRepository;

  const MessageListScreenBody({required MessageRepository messageRepository})
    : _messageRepository = messageRepository;

  @override
  State<MessageListScreenBody> createState() => _MessageListScreenBodyState();
}

class _MessageListScreenBodyState extends State<MessageListScreenBody> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200;

  late MessageListScreenBloc _messageScreenBloc;
  
  @override
  void initState() {
    super.initState();
    _messageScreenBloc = BlocProvider.of<MessageListScreenBloc>(context);
    _scrollController.addListener(_onScroll);
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _header(),
        _messageList()
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _header() {
    return SliverAppBar(
      title: Text4(text: "Message Center", context: context),
      floating: true,
      leading: Container(),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
    );
  }

  Widget _messageList() {
    return BlocBuilder<MessageListScreenBloc, MessageListScreenState>(
      builder: (context, state) {
        if (state.errorMessage.isNotEmpty) return _error(error: state.errorMessage);
        if (state.messages.isEmpty) return state.loading ? _loading() : _noMessages();

        return _messages(state: state);
      },
    );
  }

  Widget _messages({required MessageListScreenState state}) {
    return SliverPadding(
      padding: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
        ? EdgeInsets.only(left: SizeConfig.getWidth(1), right: SizeConfig.getWidth(1))
        : EdgeInsets.only(left: SizeConfig.getWidth(10), right: SizeConfig.getWidth(10)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => index >= state.messages.length
            ? BottomLoader()
            : MessageWidget(
                index: index,
                message: state.messages[index],
                messageListScreenBloc: BlocProvider.of<MessageListScreenBloc>(context),
                messageRepository: widget._messageRepository,
              ),
          childCount: state.hasReachedEnd
            ? state.messages.length
            : state.messages.length + 1,
        )
      ),
    );
  }

  Widget _error({required String error}) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text4(text: "Error: $error", context: context, color: Theme.of(context).colorScheme.error),
          Text4(text: "Please try again", context: context, color: Theme.of(context).colorScheme.error)
        ],
      ),
    );
  }
  
  Widget _loading() {
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _noMessages() {
    return SliverFillRemaining(
      child: Center(
        child: BoldText5(text: "No Messages.", context: context),
      ),
    );
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    if (!_messageScreenBloc.state.paginating && maxScroll - currentScroll <= _scrollThreshold) {
      _messageScreenBloc.add(FetchMore());
    }
  }
}