import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        style: const TextStyle(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  // tags
                  SizedBox(
                    width: 120,
                    height: 35,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      primary: true,
                      children: ActivityListTile.buildTags(activity.tags ?? []),
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
                        : Text(
                            '${AppLocalizations.of(context)!.goal}: ${activity.goal}${AppLocalizations.of(context)!.minuteLetter}',
                          ),
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
