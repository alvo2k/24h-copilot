import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/utils/constants.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/edit_mode_cubit.dart';
import 'activity_list_tile.dart';

class EditRecordsDialog extends StatefulWidget {
  const EditRecordsDialog(this.toChange, this.activityDayDate,
      {super.key, required this.addBefore});

  final DateTime activityDayDate;
  final bool addBefore;
  final Activity toChange;

  @override
  State<EditRecordsDialog> createState() => _EditRecordsDialogState();
}

class _EditRecordsDialogState extends State<EditRecordsDialog> {
  TimeOfDay? fixedTime;
  TimeOfDay? selectedTime;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> cards() {
    if (widget.addBefore) {
      return [
        NewActivityCard(_controller),
        ActivityListTile(
          widget.toChange,
          minimalVersion: true,
          hideEmojiPicker: true,
        ),
      ];
    }
    return [
      ActivityListTile(
        widget.toChange,
        minimalVersion: true,
        hideEmojiPicker: true,
      ),
      NewActivityCard(_controller),
    ];
  }

  /// is [toChange] activity starts on the edited day
  bool onSameDate() =>
      widget.toChange.startTime.isAfter(widget.activityDayDate) ||
      widget.toChange.startTime.isAtSameMomentAs(widget.activityDayDate);

  bool validateSelectedTime(TimeOfDay time) {
    if (fixedTime == null) {
      if (onSameDate()) {
        final startTime = TimeOfDay.fromDateTime(widget.toChange.startTime);
        final now = TimeOfDay.now();
        return time.isBetween(startTime, now, true);
      } else {
        final now = TimeOfDay.now();
        return time.hour < now.hour ||
            time.hour == now.hour && time.minute < now.minute;
      }
    } else {
      if (widget.addBefore) {
        final endTime =
            TimeOfDay.fromDateTime(widget.toChange.endTime ?? DateTime.now());
        return time.isBetween(fixedTime!, endTime, true);
      } else {
        if (onSameDate()) {
          final startTime = TimeOfDay.fromDateTime(widget.toChange.startTime);
          if (fixedTime!.hour == 0 && fixedTime!.minute == 0) {
            fixedTime = const TimeOfDay(hour: 23, minute: 59);
          }
          return time.isBetween(startTime, fixedTime!);
        } else {
          return time.hour < fixedTime!.hour ||
              time.hour == fixedTime!.hour && time.minute < fixedTime!.minute;
        }
      }
    }
  }

  Widget selectTime(TimeOfDay initialTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              final selectedTimeNew = await showTimePicker(
                  context: context, initialTime: initialTime);
              if (selectedTimeNew != null) {
                if (validateSelectedTime(selectedTimeNew)) {
                  setState(() {
                    selectedTime = selectedTimeNew;
                  });
                } else {
                  setState(() {
                    selectedTime = null;
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(
                        message: AppLocalizations.of(context)!.invalidTime,
                      ),
                    );
                  });
                }
              }
            },
            icon: const Icon(Icons.access_time_filled)),
        selectedTime == null
            ? const SizedBox.shrink()
            : Text(selectedTime!.format(context)),
      ],
    );
  }

  Widget buildStartTime(DateTime startTime) {
    if (widget.addBefore) {
      // startTime fixed
      if (startTime.isBefore(widget.activityDayDate)) {
        fixedTime = const TimeOfDay(hour: 0, minute: 0);
        return Text(AppLocalizations.of(context)!.startDay);
      }
      fixedTime = TimeOfDay.fromDateTime(startTime);
      return Text(fixedTime!.format(context));
    } else {
      // startTime to select
      late TimeOfDay initialTime;
      if (startTime.isBefore(widget.activityDayDate)) {
        initialTime = TimeOfDay.fromDateTime(widget.activityDayDate);
      } else {
        initialTime = TimeOfDay.fromDateTime(startTime);
      }
      return selectTime(initialTime);
    }
  }

  Widget buildEndTime(DateTime? endTime) {
    if (widget.addBefore) {
      // endTime to select
      late TimeOfDay initialTime;
      if (endTime != null &&
          endTime
              .isBefore(widget.activityDayDate.add(const Duration(days: 1)))) {
        initialTime = TimeOfDay.fromDateTime(endTime);
      } else if (endTime == null) {
        initialTime = TimeOfDay.now();
      } else {
        initialTime = const TimeOfDay(hour: 0, minute: 0);
      }
      return selectTime(initialTime);
    } else {
      // endTime fixed
      final today = DateUtils.dateOnly(DateTime.now());
      if (!widget.activityDayDate.isAtSameMomentAs(today) &&
          (endTime == null ||
              endTime.isAfter(
                  widget.activityDayDate.add(const Duration(days: 1))))) {
        fixedTime = const TimeOfDay(hour: 0, minute: 0);
        return Text(AppLocalizations.of(context)!.endDay);
      }
      if (endTime == null && widget.activityDayDate.isAtSameMomentAs(today)) {
        fixedTime = null;
        return Text(AppLocalizations.of(context)!.goesOn);
      }
      fixedTime = TimeOfDay.fromDateTime(endTime!);
      return Text(fixedTime!.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicDialogAlert(
      title: Text(AppLocalizations.of(context)!.editDay),
      content: SingleChildScrollView(
        child: Column(children: [
          ...cards(),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.startTime),
                buildStartTime(widget.toChange.startTime),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.endTime),
                buildEndTime(widget.toChange.endTime),
              ],
            ),
          ),
        ]),
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => context.pop(context),
        ),
        BasicDialogAction(
          title: Text(AppLocalizations.of(context)!.save),
          onPressed: () {
            if (selectedTime == null) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: AppLocalizations.of(context)!.pickTime,
                ),
              );
              return;
            }
            if (_controller.text.isEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: AppLocalizations.of(context)!.chooseActivity,
                ),
              );
              return;
            }
            if (_controller.text.trim().length > Constants.maxActivityName) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: AppLocalizations.of(context)!.activityNameTooLong,
                ),
              );
              return;
            }
            BlocProvider.of<ActivitiesBloc>(context).add(
              EditRecords(
                name: _controller.text.trim(),
                fixedTime: () {
                  if (fixedTime != null) {
                    if (fixedTime!.hour == 0 && fixedTime!.minute == 0) {
                      if (!widget.addBefore) {
                        return DateTime(
                          widget.activityDayDate.year,
                          widget.activityDayDate.month,
                          widget.activityDayDate.day,
                          fixedTime!.hour,
                          fixedTime!.minute,
                        ).add(const Duration(days: 1));
                      }
                    }
                    return DateTime(
                      widget.activityDayDate.year,
                      widget.activityDayDate.month,
                      widget.activityDayDate.day,
                      fixedTime!.hour,
                      fixedTime!.minute,
                    );
                  }
                }(),
                selectedTime: selectedTime == null
                    ? null
                    : DateTime(
                        widget.activityDayDate.year,
                        widget.activityDayDate.month,
                        widget.activityDayDate.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      ),
                toChange: widget.toChange,
              ),
            );
            // exit edit mode
            BlocProvider.of<EditModeCubit>(context).toggle();
            context.pop(context);
          },
        ),
      ],
    );
  }
}

class NewActivityCard extends StatefulWidget {
  const NewActivityCard(this.controller, {super.key});

  final TextEditingController controller;

  @override
  State<NewActivityCard> createState() => _NewActivityCardState();
}

class _NewActivityCardState extends State<NewActivityCard> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ActivityListTile.determineWidth(context, true),
      height: ActivityListTile.cardHeight,
      child: Card(
        shape: ActivityListTile.shape,
        color: ActivityListTile.cardColor(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ActivityListTile.buildCircle(Colors.white54),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: focusNode,
                      onEditingComplete: () => focusNode.unfocus(),
                      onSubmitted: (_) => focusNode.unfocus(),
                      onTapOutside: (_) => focusNode.unfocus(),
                      controller: widget.controller,
                      decoration: InputDecoration(
                        constraints: const BoxConstraints.expand(height: 38),
                        labelText:
                            AppLocalizations.of(context)!.newActivityPrompt,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0))),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(bottom: 8.0),
            //       child: ActivityTime(
            // TODO calculate time based on selectedTime & fixedTime
            // todo send request to DB to get activity settings and paint the card
            //         startTime:
            //             DateTime.now().subtract(const Duration(minutes: 10)),
            //         endTime: null,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

extension on TimeOfDay {
  bool isBetween(TimeOfDay startTime, TimeOfDay endTime,
      [bool encludeEndTime = false]) {
    final isBiggerStartTime = (hour > startTime.hour) ||
        (hour == startTime.hour && minute >= startTime.minute);
    final isSmallerEndTime = () {
      if (encludeEndTime) {
        return (hour < endTime.hour) ||
            (hour == endTime.hour && minute <= endTime.minute);
      } else {
        return (hour < endTime.hour) ||
            (hour == endTime.hour && minute < endTime.minute);
      }
    }();
    return isBiggerStartTime && isSmallerEndTime;
  }
}
