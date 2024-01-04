import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/widgets/activity_color.dart';
import '../../../../core/common/widgets/activity_settings_card.dart';
import '../../../../core/utils/constants.dart';
import '../bloc/card_editor_bloc.dart';
import '../widgets/setting_row.dart';

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
  late ActivitySettings activity;
  late Color color;
  late Duration? goal;
  late TextEditingController nameController;
  late List<String>? tags;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.initialActivitySettings.name);
    color = widget.initialActivitySettings.color;
    activity = widget.initialActivitySettings;
    goal = activity.goal != null ? Duration(minutes: activity.goal!) : null;
    tags = activity.tags == null ? null : List.from(activity.tags!); // copy
    super.initState();
  }

  void setColor(Color newColor) {
    setState(() {
      activity = activity.copyWith(color: newColor);
      color = newColor;
    });
  }

  void selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.pickColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: setColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              setColor(widget.initialActivitySettings.color);
              context.pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () {
              context.pop();
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
            onTimerDurationChanged: (newGoal) {
              setState(() => goal = newGoal);
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
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.green),
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

  void saveChanges() {
    if (nameController.text.trim().isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: AppLocalizations.of(context)!.activityNameIsEmpty,
        ),
      );
      return;
    }
    if (tags != null && tags!.join(';').length > Constants.maxTagsLength) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: AppLocalizations.of(context)!.tooManyTags,
        ),
      );
      return;
    }
    if (nameController.text.trim().length > Constants.maxActivityName) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: AppLocalizations.of(context)!.activityNameTooLong,
        ),
      );
      return;
    }
    BlocProvider.of<CardEditorBloc>(context).add(UpdateActivitiesSettings(
      activityName: widget.initialActivitySettings.name,
      newActivityName: nameController.text.trim(),
      newColor: color,
      newGoal: goal?.inMinutes,
      tags: tags,
    ));
    context.go('/card_editor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: saveChanges,
            child: Text(AppLocalizations.of(context)!.save),
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
                  ActivitySettingsCard(
                    name: activity.name,
                    color: activity.color,
                    goal: activity.goal != null
                        ? Duration(minutes: activity.goal!)
                        : null,
                    tags: activity.tags,
                  ),
                  SettingRow(
                      settingName: AppLocalizations.of(context)!.activityName,
                      children: [
                        TextField(
                          controller: nameController,
                          onChanged: (newName) => setState(() {
                            activity = activity.copyWith(name: newName);
                          }),
                          strutStyle: const StrutStyle(
                            height: .9,
                            leading: 0,
                            forceStrutHeight: true,
                          ),
                          cursorHeight: 18,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            constraints: BoxConstraints(
                              maxWidth: min(
                                  MediaQuery.of(context).size.width - 90, 300),
                              maxHeight: 30,
                            ),
                          ),
                        ),
                      ]),
                  SettingRow(
                    settingName: AppLocalizations.of(context)!.color,
                    children: [
                      Row(
                        children: [
                          ActivityColor(color: color),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).cardColor,
                              ),
                            ),
                            onPressed: () => selectColor(context),
                            child:
                                Text(AppLocalizations.of(context)!.changeColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SettingRow(
                    settingName: AppLocalizations.of(context)!.goal,
                    children: [
                      if (goal != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            goal!.inHours > 0
                                ? AppLocalizations.of(context)!.timeFormat(
                                    AppLocalizations.of(context)!.goal,
                                    goal!.inHours,
                                    AppLocalizations.of(context)!.hourLetter,
                                    goal!.inMinutes - goal!.inHours * 60,
                                    AppLocalizations.of(context)!.minuteLetter,
                                  )
                                : AppLocalizations.of(context)!
                                    .timeFormatMinutes(
                                    AppLocalizations.of(context)!.goal,
                                    goal!.inMinutes,
                                    AppLocalizations.of(context)!.minuteLetter,
                                  ),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: pickGoal,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).cardColor,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.selectGoal),
                      ),
                    ],
                  ),
                  SettingRow(
                    settingName: AppLocalizations.of(context)!.tags,
                    children: [
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 0,
                                      ),
                                      child: TextField(
                                        onSubmitted: addTag,
                                        strutStyle: const StrutStyle(
                                          height: .9,
                                          leading: 0,
                                          forceStrutHeight: true,
                                        ),
                                        cursorHeight: 18,
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
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
