import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../activities/presentation/widgets/activity_list_tile.dart';
import '../bloc/card_editor_bloc.dart';
import '../widgets/activity_settings_card.dart';

class ActivitySettingsPage extends StatefulWidget {
  ActivitySettingsPage({
    super.key,
    required ActivitySettings activity,
  }) {
    initialActivitySettings = activity;
  }
  late final ActivitySettings initialActivitySettings;

  @override
  State<ActivitySettingsPage> createState() => _ActivitySettingsPageState();
}

class _ActivitySettingsPageState extends State<ActivitySettingsPage> {
  late TextEditingController nameController;
  late Color color;
  late ActivitySettings activity;
  late int? goal;
  late List<String>? tags;

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.initialActivitySettings.name);
    color = widget.initialActivitySettings.color;
    activity = widget.initialActivitySettings;
    goal = activity.goal;
    tags = activity.tags == null ? null : List.from(activity.tags!); // copy
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void setColor(Color newColor) {
    setState(() {
      activity = activity.changeColor(newColor);
      color = newColor;
    });
  }

  void selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: setColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              setColor(widget.initialActivitySettings.color);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void pickGoal() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (Duration newGoal) {
              setState(() => goal = newGoal.inMinutes);
            },
          );
        });
  }

  void addTag(String tag) {
    setState(() {
      if (tags != null) {
        if (!tags!.contains(tag)) tags?.add(tag);
      } else {
        tags = [tag];
      }
    });
  }

  List<Widget> buildTags(List<String> activityTags) {
    if (activityTags.isEmpty) {
      return [];
    }
    return activityTags
        .map((tag) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '#$tag',
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tags!.remove(tag);
                        });
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }

  saveChanges() {
    if (nameController.text.trim().isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Activity name cannot be empty',
        ),
      );
      return;
    }
    BlocProvider.of<CardEditorBloc>(context).add(UpdateActivitiesSettings(
      activityName: widget.initialActivitySettings.name,
      newActivityName: nameController.text.trim(),
      newColor: color,
      newGoal: goal,
      tags: tags,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveChanges,
            icon: const Icon(Icons.save),
          ),
        ],
        title: Text(widget.initialActivitySettings.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              width: min(MediaQuery.of(context).size.width, 400),
              child: Column(
                children: [
                  ActivitySettingsCard(activity: activity, onPressed: () {}),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextField(
                          controller: nameController,
                          onChanged: (newName) => setState(() {
                            activity = activity.changeName(newName);
                          }),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            constraints: BoxConstraints(
                              maxWidth: min(
                                  MediaQuery.of(context).size.width - 90, 300),
                              maxHeight: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Color:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            ActivityListTile.buildCircle(color),
                            ElevatedButton(
                              onPressed: () {
                                selectColor(context);
                              },
                              child: const Text('Change color'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Goal:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            goal == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text('$goal minutes'),
                                  ),
                            ElevatedButton(
                                onPressed: pickGoal,
                                child: const Text('Pick a goal')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tags:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: max(constraints.maxWidth, 150),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ...buildTags(tags ?? []),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 0,
                                          ),
                                          child: TextField(
                                            onSubmitted: addTag,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              prefixText: '# ',
                                              border: InputBorder.none,
                                              constraints: BoxConstraints(
                                                maxWidth: 120,
                                                maxHeight: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on ActivitySettings {
  ActivitySettings changeColor(Color newColor) => ActivitySettings(
        name: name,
        color: newColor,
        goal: goal,
        tags: tags,
      );
  ActivitySettings changeName(String newName) => ActivitySettings(
        name: newName,
        color: color,
        goal: goal,
        tags: tags,
      );
}
