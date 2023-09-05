import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ActivityDayDate extends StatelessWidget {
  const ActivityDayDate(this.date, {super.key});

  final DateTime date;

  static String formatDate(DateTime date, BuildContext context,
      [String format = DateFormat.MONTH_WEEKDAY_DAY]) {
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
    return DateFormat(format, Localizations.localeOf(context).languageCode)
        .format(date);
    // return date.toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            formatDate(date, context),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
