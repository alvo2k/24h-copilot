import 'package:copilot/features/activities/presentation/widgets/activity_day_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entities/activity.dart';
import 'activity_list_tile.dart';
import 'activity_time.dart';

class InsertActivityDialog extends StatefulWidget {
  const InsertActivityDialog(this.toChange, this.activityDayDate,
      {super.key, required this.addBefore});

  final Activity toChange;
  final bool addBefore;
  final DateTime activityDayDate;

  @override
  State<InsertActivityDialog> createState() => _InsertActivityDialogState();
}

class _InsertActivityDialogState extends State<InsertActivityDialog> {
  final _controller = TextEditingController();
  TimeOfDay? selectedTime;
  TimeOfDay? fixedTime;

  List<Widget> cards() {
    if (widget.addBefore) {
      return [
        NewActivityCard(_controller),
        ActivityListTile(
          widget.toChange,
          minimalVersion: true,
        ),
      ];
    }
    return [
      ActivityListTile(
        widget.toChange,
        minimalVersion: true,
      ),
      NewActivityCard(_controller),
    ];
  }

  bool validateSelectedTime(TimeOfDay time) {
    // toChange activity begins on the edited day
    if (widget.toChange.startTime.isAfter(widget.activityDayDate) || widget.toChange.startTime.isAtSameMomentAs(widget.activityDayDate)) {
      if (fixedTime == null) { // fixedTime is null only if the inserted activity is inserted at the end
        // time should be after or at the same moment as startTime
        final startTime = TimeOfDay.fromDateTime(widget.toChange.startTime);
        return time.hour >= startTime.hour && time.minute >= startTime.minute;
      }
    } else { // toChange activity started before the edited day
      if (widget.addBefore) {
        final endTime = TimeOfDay.fromDateTime(widget.toChange.endTime ?? DateTime.now());
        return time.hour <= endTime.hour && time.minute <= endTime.minute;
      } else {

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
                  // toast select valid time
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
        return const Text('Начало дня');
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
        return const Text('До конца дня');
      }
      if (endTime == null && widget.activityDayDate.isAtSameMomentAs(today)) {
        fixedTime = null;
        return const Text('Продолжается...');
      }
      fixedTime = TimeOfDay.fromDateTime(endTime!);
      return Text(fixedTime!.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicDialogAlert(
      title: const Text('Редактирование дня'),
      content: SingleChildScrollView(
        child: Column(children: [
          ...cards(),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Начальное время'),
                buildStartTime(widget.toChange.startTime),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Конечное время'),
                buildEndTime(widget.toChange.endTime),
              ],
            ),
          ),
        ]),
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        BasicDialogAction(
          title: const Text('Save'),
          onPressed: () {},
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
                SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      constraints: BoxConstraints.expand(
                          width: MediaQuery.of(context).size.width - 76,
                          height: 40),
                      suffixIcon: IconButton(
                        iconSize: 24,
                        tooltip: 'New activity',
                        splashRadius: 20.0,
                        icon: const Icon(Icons.edit),
                        onPressed: widget.controller.text.isEmpty
                            ? null
                            : () {
                                //todo
                              },
                      ),
                      hintText: AppLocalizations.of(context)!.newActivityPrompt,
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(24.0))),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ActivityTime(
                    startTime:
                        DateTime.now().subtract(const Duration(minutes: 10)),
                    endTime: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
