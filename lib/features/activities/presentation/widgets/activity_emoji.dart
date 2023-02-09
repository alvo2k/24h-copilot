import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../../domain/entities/activity.dart';
import '../bloc/activities_bloc.dart';
import 'emoji_dialog_picker.dart';

class ActivityEmoji extends StatefulWidget {
  const ActivityEmoji(this.activity, {super.key});

  final Activity activity;

  @override
  State<ActivityEmoji> createState() => _ActivityEmojiState();
}

class _ActivityEmojiState extends State<ActivityEmoji> {
  String? emoji;

  Future<void> showDialogPicker(
      BuildContext context, ActivitiesBloc activityBloc) {
    return showPlatformDialog(
      context: context,
      builder: (context) {
        return EmojiDialogPicker(
          onEmojiSelected: (selectedEmoji) {
            activityBloc.add(ActivitiesEvent.addEmoji(
                widget.activity.recordId, selectedEmoji));
            setState(() {
              emoji = selectedEmoji;
            });
          },
        );
      },
    );
  }

  bool _shouldBuild() {
    if (widget.activity.endTime == null) return false;

    final bool tooOld = widget.activity.endTime!
        .isBefore(DateTime.now().subtract(const Duration(hours: 1)));
    return !tooOld;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasEmoji = widget.activity.emoji != null;
    if (!_shouldBuild() && !hasEmoji) return Container();
    if (hasEmoji) {
      emoji = widget.activity.emoji;
    }
    final activityBloc = BlocProvider.of<ActivitiesBloc>(context);
    return emoji == null
        ? TextButton(
            child: const Text('how was it?'),
            onPressed: () => showDialogPicker(context, activityBloc))
        : Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () => showDialogPicker(context, activityBloc),
              child: Text(
                emoji!,
                style: TextStyle(fontSize: 24, shadows: [
                  Shadow(
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                    color: Colors.black38.withAlpha(60),
                  )
                ]),
              ),
            ),
          );
  }
}
