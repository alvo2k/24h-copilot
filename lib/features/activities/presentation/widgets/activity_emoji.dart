import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'emoji_dialog_picker.dart';

class ActivityEmoji extends StatelessWidget {
  const ActivityEmoji({
    required this.emoji,
    required this.onEmojiSelected,
    super.key,
  });

  final String? emoji;
  final void Function(String newEmoji)? onEmojiSelected;

  void showDialogPicker(BuildContext context) => showPlatformDialog(
        androidBarrierDismissible: true,
        context: context,
        builder: (context) => EmojiDialogPicker(
          onEmojiSelected: onEmojiSelected!,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return emoji == null
        ? Visibility(
            visible: onEmojiSelected != null,
            child: TextButton(
              child: Text(AppLocalizations.of(context)!.emojiSelectPrompt),
              onPressed: () => showDialogPicker(context),
            )
                .animate(
                  autoPlay: false,
                  onInit: (controller) => controller.repeat(),
                )
                .shimmer(delay: 5.seconds, duration: 3.seconds),
          )
        : TextButton(
            onPressed: onEmojiSelected != null
                ? () => showDialogPicker(context)
                : null,
            child: Text(
              emoji!,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'NotoColorEmoji',
                // to avoid tinted emoji when [TextButton] is disabled
                color: Colors.red,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                    color: Colors.black38.withAlpha(60),
                  )
                ],
              ),
            ),
          );
  }
}
