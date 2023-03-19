import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../../domain/entities/activity.dart';
import 'insert_activity_dialog.dart';

class EditModeSeparator extends StatelessWidget {
  const EditModeSeparator(this.toChange, this.activityDayDate,
      {super.key, required this.addBefore});

  final Activity toChange;

  /// Should the new activity be inserted before the existing one or after it
  final bool addBefore;

  /// The date on which the [toChange] activity card is in
  final DateTime activityDayDate;

  showInsertActivityDialog(BuildContext context) => showPlatformDialog(
        context: context,
        androidBarrierDismissible: true,
        builder: (context) => InsertActivityDialog(
          toChange,
          activityDayDate,
          addBefore: addBefore,
        ),
      );

  buildIcon(Color color) => Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 15,
          color: color,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color ?? Colors.black87;
    return TextButton(
      onPressed: () => showInsertActivityDialog(context),
      child: Row(
        children: [
          buildIcon(color),
          SizedBox.fromSize(
            // just gap
            size: const Size(4, 1),
          ),
          Expanded(
            child: DottedLine(
              dashColor: color,
              lineThickness: 3,
              dashGapLength: 15,
              dashLength: 15,
              dashRadius: 5,
            ),
          ),
        ],
      ),
    );
  }
}
