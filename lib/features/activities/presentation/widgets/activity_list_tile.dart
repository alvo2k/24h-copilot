import 'package:copilot/features/activities/presentation/widgets/activity_emoji.dart';
import 'package:copilot/features/activities/presentation/widgets/activity_time.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/activity.dart';

class ActivityListTile extends StatelessWidget {
  final Activity activity;
  const ActivityListTile(this.activity, {super.key});

  static const _cardHeight = 120.0;
  @override
  Widget build(BuildContext context) {
    const leftPadding = 40.0;
    const rightPadding = 8.0;
    const leftBarWidth = 4.0;
    final cardWidth = MediaQuery.of(context).size.width > 500
        ? 500 - leftPadding - leftBarWidth - rightPadding
        : MediaQuery.of(context).size.width -
            leftPadding -
            leftBarWidth -
            rightPadding;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: leftPadding, right: rightPadding),
          child: Container(
            color: activity.color,
            width: leftBarWidth,
            height: _determineHeight(
                activity.endTime == null
                    ? DateTime.now().difference(activity.startTime)
                    : activity.endTime!.difference(activity.startTime),
                context),
          ),
        ),
        // card
        SizedBox(
          width: cardWidth,
          height: _cardHeight,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: const Color.fromRGBO(226, 226, 226, 1),
            child: Column(
              children: [
                // color, name, tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // color, name
                    Row(
                      children: [
                        _buildCircle(),
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
                        children: _buildTags(activity.tags ?? []),
                      ),
                    ),
                  ],
                ),
                // emoji, goal, time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActivityEmoji(activity),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        activity.goal == null
                            ? Container()
                            : Text('Goal: ${activity.goal}'),
                        ActivityTime(
                          startTime: activity.startTime,
                          endTime: activity.endTime,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: activity.color, // border color
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  List<Widget> _buildTags(List<String> tags) {
    if (tags.isEmpty) {
      return [];
    }
    return tags
        .map((tag) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Text(
                  '#$tag',
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
            ))
        .toList();
  }

  double _determineHeight(Duration duration, BuildContext context) {
    const hourValue = 28.0;
    // todo: make this dynamic (maxHeight - appBarHeight - bottomBarHeight)
    final maxHeight = MediaQuery.of(context).size.height - 200;
    final height = _cardHeight + (hourValue * duration.inHours);

    return height > maxHeight ? maxHeight : height;
  }
}
