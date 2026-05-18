import 'package:flutter/material.dart';
import 'theme.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbleDecoration = isUserMessage
        ? ChatRoomTheme.userMessageBubbleDecoration
        : ChatRoomTheme.aiMessageBubbleDecoration;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: bubbleDecoration,
        child: Text(
          text,
          style: ChatRoomTheme.textStyle,
        ),
      ),
    );
  }
}
