import 'package:dashboard/resources/helpers/cupertino_box_decoration.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/message_screen/bloc/message_history_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:dashboard/theme/main_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/message_input_bloc.dart';

class MessageInput extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late MessageInputBloc _messageInputBloc;
  
  @override
  void initState() {
    super.initState();
    _messageInputBloc = BlocProvider.of<MessageInputBloc>(context);
    _controller.addListener(_onInputChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      child: _input(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _messageInputBloc.close();
    super.dispose();
  }

  Widget _input() {
    return BlocConsumer<MessageInputBloc, MessageInputState>(
      listenWhen: (previous, current) {
        return previous.isSubmitting && !current.isSubmitting;
      },
      listener: (context, state) {
        if (state.errorMessage.isEmpty) {
          _controller.text = "";
        } else {
          _showError(context: context, state: state);
        }
        
      },
      builder: (context, state) {
        return CupertinoTextField(
          decoration: CupertinoBoxDecoration.validator(isValid: state.isInputValid || _controller.text.isEmpty, borderRadius: 20),
          cursorColor: Colors.black,
          textCapitalization: TextCapitalization.sentences,
          placeholder: "Type Message",
          style: MainTheme.getDefaultFont().copyWith(
            fontWeight: FontWeight.normal,
            fontSize: FontSizeAdapter.setSize(size: 2.5, context: context)
          ),
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.send,
          autocorrect: true,
          maxLines: 3,
          onSubmitted: (_) => _submitButtonPressed,
          suffix: _submitButton(state: state),
        );
      }
    );
  }

  Widget _submitButton({required MessageInputState state}) {
    return state.isSubmitting
      ? Padding(padding: EdgeInsets.only(right: 5), child: CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction))
      : IconButton(
          key: Key("submitButtonKey"),
          icon: Icon(Icons.send), 
          iconSize: FontSizeAdapter.setSize(size: 4, context: context),
          onPressed: state.isInputValid && _controller.text.isNotEmpty
            ? () => _submitButtonPressed()
            : null,
          color: Theme.of(context).colorScheme.callToAction,
        );

  }
  
  void _onInputChanged() {
    _messageInputBloc.add(MessageChanged(message: _controller.text));
  }
  
  void _submitButtonPressed() {
    _focusNode.unfocus();
    _messageInputBloc.add(Submitted(
      message: _controller.text,
      messageIdentifier: BlocProvider.of<MessageHistoryBloc>(context).state.message.identifier
    ));
  }

  void _showError({required BuildContext context, required MessageInputState state}) {
    ToastMessage(
      context: context,
      message: state.errorMessage,
      color: Theme.of(context).colorScheme.danger
    ).showToast();
  }
}