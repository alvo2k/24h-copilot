import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmojiButton extends StatelessWidget {
  const EmojiButton(this.emoji, this.onEmojiSelected, {super.key});

  final String emoji;
  final Function(String) onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        emoji,
        style: TextStyle(
          fontFamily: 'NotoColorEmoji',
          fontSize: 30,
          shadows: [
            Shadow(
              blurRadius: 8,
              offset: const Offset(4, 4),
              color: Colors.black38.withAlpha(60),
            )
          ],
        ),
      ),
      onPressed: () {
        onEmojiSelected(emoji);
        context.pop(context);
      },
    );
  }
}
