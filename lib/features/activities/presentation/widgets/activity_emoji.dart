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
  bool _shouldBuild() {
    if (widget.activity.endTime == null) return false;
    
    final bool tooOld = widget.activity.endTime!
        .isAfter(DateTime.now().subtract(const Duration(days: 1)));
    return tooOld;
  }

  String? emoji;

  @override
  Widget build(BuildContext context) {
    if (!_shouldBuild()) return Container();
    if (widget.activity.emoji != null) {
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
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
  }

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
}
