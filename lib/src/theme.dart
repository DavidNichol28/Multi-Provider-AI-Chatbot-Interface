// theme.dart
import 'package:flutter/material.dart';

class ChatRoomTheme {
  static const Color backgroundColor = Colors.black;
  static const Color navBarColor = Colors.blue;
  static const Color textColor = Colors.white70;
  static const Color userMessageBubbleColor = Colors.blue;
  static const Color aiMessageBubbleColor = Colors.grey;
  static const double bubbleBorderRadius = 10.0;

  static TextStyle get textStyle => TextStyle(color: textColor);

  static BoxDecoration get userMessageBubbleDecoration => BoxDecoration(
        color: userMessageBubbleColor,
        borderRadius: BorderRadius.circular(bubbleBorderRadius),
      );

  static BoxDecoration get aiMessageBubbleDecoration => BoxDecoration(
        color: aiMessageBubbleColor,
        borderRadius: BorderRadius.circular(bubbleBorderRadius),
      );

  static InputDecoration get inputDecoration => InputDecoration(
        hintText: "Type a message...",
        hintStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white24,
      );
}
