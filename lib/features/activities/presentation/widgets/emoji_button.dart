import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  const EmojiButton(this.emoji, this.onEmojiSelected, {super.key});

  final String emoji;
  final Function(String) onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(emoji, style: const TextStyle(fontSize: 30)),
      onPressed: () {
        onEmojiSelected(emoji);
        Navigator.pop(context);
      },
    );
  }
}
