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
import '../../domain/entities/validation_errors.dart';
import '../bloc/card_editor_bloc.dart';
import '../widgets/deletable_activity_tag.dart';
import '../widgets/new_tag_text_field.dart';
import '../widgets/setting_row.dart';

class ActivitySettingsPage extends StatefulWidget {
  ActivitySettingsPage({
    super.key,
    required ActivitySettings activity,
  }) {
    initialActivitySettings = activity;
  }

  late final ActivitySettings initialActivitySettings;

  static Future<bool> onExit(BuildContext context) async {
    final state = context.read<CardEditorBloc>().state;
    if (state.initialActivitySettings != state.editedActivitySettings) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.doYouWantToExit),
            content: Text(AppLocalizations.of(context)!.editsWontBeSaved),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(AppLocalizations.of(context)!.confirm),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      return result ?? false;
    }
    return true;
  }

  @override
  State<ActivitySettingsPage> createState() => _ActivitySettingsPageState();
}

class _ActivitySettingsPageState extends State<ActivitySettingsPage> {
  late final TextEditingController nameController =
      TextEditingController(text: widget.initialActivitySettings.name);

  @override
  void initState() {
    super.initState();
    context.read<CardEditorBloc>().add(
          ActivitySelected(
            widget.initialActivitySettings,
          ),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectColor(BuildContext context, Color initial) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.pickColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initial,
            onColorChanged: (color) => context.read<CardEditorBloc>().add(
                  UpdateField(color: color),
                ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              context.read<CardEditorBloc>().add(
                    UpdateField(color: widget.initialActivitySettings.color),
                  );
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

  List<Widget> buildTags(List<String> activityTags) {
    if (activityTags.isEmpty) {
      return [];
    }
    final bloc = context.read<CardEditorBloc>();
    return activityTags
        .map(
          (tag) => DeletableActivityTag(
            key: UniqueKey(),
            tag: tag,
            onDeleted: () => bloc.add(
              UpdateField(
                tags: List.from(activityTags)
                  ..removeWhere((element) => element == tag),
              ),
            ),
          ),
        )
        .toList();
  }

  void pickGoal() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (newGoal) =>
                context.read<CardEditorBloc>().add(
                      UpdateField(
                        goal: newGoal.inMinutes,
                      ),
                    ),
          );
        });
  }

  void _listener(BuildContext context, CardEditorState state) {
    if (state.type != null) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: state.type!.localize(context),
        ),
      );
    }
    if (state.validationErrors != null) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: switch (state.validationErrors!) {
            ValidationErrors.activityNameTooLong =>
              AppLocalizations.of(context)!.activityNameTooLong,
            ValidationErrors.activityNameIsEmpty =>
              AppLocalizations.of(context)!.activityNameIsEmpty,
            ValidationErrors.tooManyTags =>
              AppLocalizations.of(context)!.tooManyTags,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.read<CardEditorBloc>().add(
                  SaveChanges(
                    onSuccess: () => context.go('/card_editor'),
                  ),
                ),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
        title: Text(widget.initialActivitySettings.name),
        centerTitle: true,
      ),
      body: BlocConsumer<CardEditorBloc, CardEditorState>(
        listener: _listener,
        builder: (context, state) {
          if (state.editedActivitySettings == null ||
              state.initialActivitySettings == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final settings = state.editedActivitySettings!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: min(MediaQuery.of(context).size.width, 400),
                  child: Column(
                    children: [
                      ActivitySettingsCard(
                        name: settings.name,
                        color: settings.color,
                        goal: settings.goal != null
                            ? Duration(minutes: settings.goal!)
                            : null,
                        tags: settings.tags,
                      ),
                      SettingRow(
                          settingName:
                              AppLocalizations.of(context)!.activityName,
                          children: [
                            Flexible(
                              child: TextField(
                                controller: nameController,
                                onChanged: (newName) =>
                                    context.read<CardEditorBloc>().add(
                                          UpdateField(
                                            activityName: newName,
                                          ),
                                        ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLength: 20,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 2,
                                ),
                                strutStyle: const StrutStyle(
                                  height: 1,
                                  forceStrutHeight: true,
                                ),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  suffixText: '  ',
                                  prefixText: '  ',
                                  hintText: AppLocalizations.of(context)!
                                      .activityName,
                                  constraints: const BoxConstraints(
                                    maxWidth: 260,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                      SettingRow(
                        settingName: AppLocalizations.of(context)!.color,
                        children: [
                          Row(
                            children: [
                              ActivityColor(color: settings.color),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).cardColor,
                                  ),
                                ),
                                onPressed: () => selectColor(
                                  context,
                                  settings.color,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.changeColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SettingRow(
                        settingName: AppLocalizations.of(context)!.goal,
                        children: [
                          if (settings.goalDuration != null)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    settings.goalDuration!.inHours > 0
                                        ? AppLocalizations.of(context)!
                                            .timeFormat(
                                            AppLocalizations.of(context)!.goal,
                                            settings.goalDuration!.inHours,
                                            AppLocalizations.of(context)!
                                                .hourLetter,
                                            settings.goalDuration!.inMinutes -
                                                settings.goalDuration!.inHours *
                                                    60,
                                            AppLocalizations.of(context)!
                                                .minuteLetter,
                                          )
                                        : AppLocalizations.of(context)!
                                            .timeFormatMinutes(
                                            AppLocalizations.of(context)!.goal,
                                            settings.goalDuration!.inMinutes,
                                            AppLocalizations.of(context)!
                                                .minuteLetter,
                                          ),
                                  ),
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
                            child: Text(
                              settings.goalDuration != null
                                  ? AppLocalizations.of(context)!.changeGoal
                                  : AppLocalizations.of(context)!.selectGoal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.tags}:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: 8),
                            ...buildTags(settings.tags ?? []),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: NewTagTextField(
                                onSubmitted: (newTag) =>
                                    context.read<CardEditorBloc>().add(
                                          UpdateField(
                                            tags: List.from(settings.tags ?? [])
                                              ..add(newTag),
                                          ),
                                        ),
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
          );
        },
      ),
    );
  }
}
