import '../bloc/minute_timer_cubit.dart';
import 'package:flutter/widgets.dart';

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

          if (hours > 0) {
            return Text('Already: ${hours}h ${totalMinutes - hours * 60}m');
          } else {
            return Text('Already: ${totalMinutes}m');
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
