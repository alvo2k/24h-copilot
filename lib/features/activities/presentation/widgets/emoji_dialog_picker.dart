import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'emoji_button.dart';

class EmojiDialogPicker extends StatelessWidget {
  const EmojiDialogPicker({super.key, required this.onEmojiSelected});

  final Function(String) onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return BasicDialogAlert(
      title: const Text('Pick an emoji'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmojiButton('👍', onEmojiSelected),
              EmojiButton('👎', onEmojiSelected),
              EmojiButton('😀', onEmojiSelected),
              EmojiButton('🙁', onEmojiSelected),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmojiButton('🥳', onEmojiSelected),
              EmojiButton('🫠', onEmojiSelected),
              EmojiButton('😐', onEmojiSelected),
              EmojiButton('😡', onEmojiSelected),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmojiButton('😫', onEmojiSelected),
              EmojiButton('😊', onEmojiSelected),
              EmojiButton('🙃', onEmojiSelected),
              EmojiButton('🤪', onEmojiSelected),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmojiButton('🤑', onEmojiSelected),
              EmojiButton('🫣', onEmojiSelected),
              EmojiButton('🤔', onEmojiSelected),
              EmojiButton('😮‍💨', onEmojiSelected),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmojiButton('😴', onEmojiSelected),
              EmojiButton('🤮', onEmojiSelected),
              EmojiButton('😎', onEmojiSelected),
              EmojiButton('😢', onEmojiSelected),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
