import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'emoji_button.dart';

class EmojiDialogPicker extends StatelessWidget {
  const EmojiDialogPicker({super.key, required this.onEmojiSelected});

  final Function(String) onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return BasicDialogAlert(
      title: Text(AppLocalizations.of(context)!.pickEmoji),
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
          title: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
