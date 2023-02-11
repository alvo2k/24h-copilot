import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/minute_timer_cubit.dart';

class ActivityTime extends StatefulWidget {
  const ActivityTime(
      {required this.startTime, required this.endTime, super.key});

  final DateTime? endTime;
  final DateTime startTime;

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
        if (widget.endTime == null) {
          final now = DateTime.now();
          final totalMinutes = now.difference(widget.startTime).inMinutes;
          final hours = now.difference(widget.startTime).inHours;

          final hourLetter = AppLocalizations.of(context)!.hourLetter;
          final minuteLetter = AppLocalizations.of(context)!.minuteLetter;
          if (hours > 0) {
            return Text(AppLocalizations.of(context)!.alreadyTime(
              hours,
              hourLetter,
              totalMinutes - hours * 60,
              minuteLetter,
            ));
          } else {
            return Text(AppLocalizations.of(context)!
                .alreadyTimeMinutes(totalMinutes, minuteLetter));
          }
        } else {
          final totalMinutes =
              widget.endTime!.difference(widget.startTime).inMinutes;
          final hours = widget.endTime!.difference(widget.startTime).inHours;

          if (hours > 0) {
            return Text('Total: ${hours}h ${totalMinutes - hours * 60}m');
          } else {
            return Text('Total: ${totalMinutes}m');
          }
        }
      },
    );
  }
}
