import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/minute_timer_cubit.dart';

class ActivityTime extends StatefulWidget {
  const ActivityTime({
    required this.startTime,
    required this.endTime,
    this.duration,
    super.key,
  });

  final DateTime? endTime;
  final DateTime startTime;
  final Duration? duration;

  @override
  State<ActivityTime> createState() => _ActivityTimeState();
}

class _ActivityTimeState extends State<ActivityTime> {
  late MinuteTimerCubit _cubit;

  @override
  void dispose() {
    _cubit.stopTimer();
    _cubit.close();
    super.dispose();
  }

  @override
  void initState() {
    _cubit = MinuteTimerCubit.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cubit.stream,
      builder: (context, snapshot) {
        final totalPrefix = AppLocalizations.of(context)!.totalPrefix;
        final alreadyPrefix = AppLocalizations.of(context)!.alreadyPrefix;
        final hourLetter = AppLocalizations.of(context)!.hourLetter;
        final minuteLetter = AppLocalizations.of(context)!.minuteLetter;

        if (widget.duration != null) {
          final totalMinutes = widget.duration!.inMinutes;
          final hours = widget.duration!.inHours;
          return Text(AppLocalizations.of(context)!.timeFormat(
            'В этом промежутке: ',
            hours,
            hourLetter,
            totalMinutes - hours * 60,
            minuteLetter,
          ));
        }

        if (widget.endTime == null) {
          final now = DateTime.now();
          final totalMinutes = now.difference(widget.startTime).inMinutes;
          final hours = now.difference(widget.startTime).inHours;

          if (hours > 0) {
            return Text(AppLocalizations.of(context)!.timeFormat(
              alreadyPrefix,
              hours,
              hourLetter,
              totalMinutes - hours * 60,
              minuteLetter,
            ));
          } else {
            return Text(AppLocalizations.of(context)!
                .timeFormatMinutes(alreadyPrefix, totalMinutes, minuteLetter));
          }
        } else {
          final totalMinutes =
              widget.endTime!.difference(widget.startTime).inMinutes;
          final hours = widget.endTime!.difference(widget.startTime).inHours;

          if (hours > 0) {
            return Text(AppLocalizations.of(context)!.timeFormat(
              totalPrefix,
              hours,
              hourLetter,
              totalMinutes - hours * 60,
              minuteLetter,
            ));
          } else {
            return Text(AppLocalizations.of(context)!
                .timeFormatMinutes(totalPrefix, totalMinutes, minuteLetter));
          }
        }
      },
    );
  }
}
