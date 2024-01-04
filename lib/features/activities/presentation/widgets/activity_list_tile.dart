import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaled_app/scaled_app.dart';

import '../../../../core/common/widgets/activity_settings_card.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activities_bloc.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile(this.activity, {super.key});

  static const cardHeight = 125.0;

  final Activity activity;

  static List<Widget> buildTags(List<String> tags, context) {
    if (tags.isEmpty) {
      return [];
    }
    return tags
        .map((tag) => SizedBox(
              height: 35,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Text(
                    '#$tag',
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.green),
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget _buildLeftBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 8),
      child: Container(
        color: activity.color,
        width: 4,
        height: _determineLeftBarHeight(
            activity.endTime == null
                ? DateTime.now().difference(activity.startTime)
                : activity.endTime!.difference(activity.startTime),
            context),
      ),
    );
  }

  double _determineLeftBarHeight(Duration duration, BuildContext context) {
    final hourValue = 28.0 / ScaledWidgetsFlutterBinding.instance.scale;
    // todo: make this dynamic (maxHeight - appBarHeight - bottomBarHeight)
    final maxHeight = (MediaQuery.of(context).size.height /
            ScaledWidgetsFlutterBinding.instance.scale) -
        200;
    final height = cardHeight + (hourValue * duration.inHours);

    return height > maxHeight ? maxHeight : height;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLeftBar(context),
        Flexible(
          child: ActivitySettingsCard(
            name: activity.name,
            color: activity.color,
            goal:
                activity.goal != null ? Duration(minutes: activity.goal!) : null,
            goalReached: activity.goalMet,
            tags: activity.tags,
            startTime: activity.startTime,
            endTime: activity.endTime,
            emoji: activity.emoji,
            onEmojiSelected: activity.canChangeEmoji
                ? (newEmoji) => context.read<ActivitiesBloc>().add(
                      AddEmoji(
                        activity.recordId,
                        newEmoji,
                      ),
                    )
                : null,
          ),
        ),
      ],
    );
  }
}
