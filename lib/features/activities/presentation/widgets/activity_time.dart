import 'package:flutter/widgets.dart';

class ActivityTime extends StatelessWidget {
  const ActivityTime(
      {required this.startTime, required this.endTime, super.key});

  final DateTime startTime;
  final DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    // todo update every minute
    if (endTime == null) {
      final now = DateTime.now();
      final totalMinutes = now.difference(startTime).inMinutes;
      final hours = now.difference(startTime).inHours;

      if (hours > 0) {
        return Text('Already: ${hours}h ${totalMinutes - hours * 60}m');
      } else {
        return Text('Already: ${totalMinutes}m');
      }
    } else {
      final totalMinutes = endTime!.difference(startTime).inMinutes;
      final hours = endTime!.difference(startTime).inHours;

      if (hours > 0) {
        return Text('Total: ${hours}h ${totalMinutes - hours * 60}m');
      } else {
        return Text('Total: ${totalMinutes}m');
      }
    }
  }
}
