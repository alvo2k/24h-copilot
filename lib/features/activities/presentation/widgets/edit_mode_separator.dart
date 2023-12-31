import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../../domain/entities/activity.dart';
import 'edit_records_dialog.dart';

class EditModeSeparator extends StatelessWidget {
  const EditModeSeparator(
    this.toChange,
    this.activityDayDate, {
    required this.addBefore,
    required this.sizeAnimation,
    required this.opacityAnimation,
    super.key,
  });

  /// The date on which the [toChange] activity card is in
  final DateTime activityDayDate;

  /// Should the new activity be inserted before the existing one or after it
  final bool addBefore;

  final Activity toChange;

  final Animation<double> sizeAnimation;

  final Animation<double> opacityAnimation;

  showEditRecordsDialog(BuildContext context) => showPlatformDialog(
        context: context,
        androidBarrierDismissible: true,
        builder: (context) => EditRecordsDialog(
          toChange,
          activityDayDate,
          addBefore: addBefore,
        ),
      );

  buildIcon(Color color, double sizePercentage) => Container(
        width: 24.0,
        height: 24.0 * sizePercentage,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 15 * sizePercentage,
          color: color,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color ?? Colors.black87;
    return AnimatedBuilder(
      key: const PageStorageKey('activityListView'),
      animation: sizeAnimation,
      builder: (context, _) => FadeTransition(
        opacity: opacityAnimation,
        child: SizedBox(
          height: 28 * sizeAnimation.value,
          child: TextButton(
            onPressed: () => showEditRecordsDialog(context),
            child: Row(
              children: [
                buildIcon(color, sizeAnimation.value),
                const SizedBox(width: 4),
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
          ),
        ),
      ),
    );
  }
}
