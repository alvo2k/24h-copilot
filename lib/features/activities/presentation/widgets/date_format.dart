
import 'package:flutter/material.dart';

class DateFormat extends StatelessWidget {
  const DateFormat(this.date, {super.key});

  final DateTime date;

  String defineText(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return AppLocalizations.of(context)!.today;
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return AppLocalizations.of(context)!.yesterday;
    }
    return date.toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            defineText(date, context),
            style: TextStyle(fontSize: 28, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
