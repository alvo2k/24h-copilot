import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../activities/presentation/widgets/activity_list_tile.dart';

class ActivitySettingsCard extends StatelessWidget {
  const ActivitySettingsCard({
    super.key,
    required this.activity,
    required this.onPressed,
  });

  final ActivitySettings activity;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ActivityListTile.determineWidth(context, false),
      height: ActivityListTile.cardHeight,
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          shape: ActivityListTile.shape,
          color: ActivityListTile.cardColor(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // color, name
                  Row(
                    children: [
                      ActivityListTile.buildCircle(activity.color),
                      Text(
                        activity.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  // tags
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: max(constraints.maxWidth, 150),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: ActivityListTile.buildTags(
                                  activity.tags ?? [], context),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    activity.goal == null
                        ? const SizedBox.shrink()
                        : ActivityListTile.buildGoal(activity.goal!, context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
