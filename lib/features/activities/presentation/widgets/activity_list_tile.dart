import 'package:flutter/material.dart';

import '../../domain/entities/activity.dart';
import 'activity_emoji.dart';
import 'activity_time.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile(
    this.activity, {
    super.key,
    this.minimalVersion = false,
    this.padding = 76,
    this.hideEmojiPicker = false,
  });

  static const cardHeight = 122.0;

  final Activity activity;
  final bool hideEmojiPicker;
  final bool minimalVersion;
  final double padding;

  static const _leftBarWidth = 4.0;
  static const _leftPadding = 40.0;
  static const _rightPadding = 8.0;

  static Widget buildCircle(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color, // border color
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static double determineWidth(BuildContext context, bool minimalVersion,
      [double padding = 76]) {
    var preferredWidth = 500.0;
    if (minimalVersion) {
      preferredWidth =
          MediaQuery.of(context).size.width - padding > preferredWidth
              ? preferredWidth
              : MediaQuery.of(context).size.width - padding;
    }
    return MediaQuery.of(context).size.width > preferredWidth
        ? preferredWidth - _leftPadding - _leftBarWidth - _rightPadding
        : MediaQuery.of(context).size.width -
            _leftPadding -
            _leftBarWidth -
            _rightPadding;
  }

  static cardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color.fromRGBO(226, 226, 226, 1)
        : const Color.fromARGB(255, 25, 25, 25);
  }

  static ShapeBorder get shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  Widget _buildLeftBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: _leftPadding, right: _rightPadding),
      child: Container(
        color: activity.color,
        width: _leftBarWidth,
        height: _determineLeftBarHeight(
            activity.endTime == null
                ? DateTime.now().difference(activity.startTime)
                : activity.endTime!.difference(activity.startTime),
            context),
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

  double _determineLeftBarHeight(Duration duration, BuildContext context) {
    const hourValue = 28.0;
    // todo: make this dynamic (maxHeight - appBarHeight - bottomBarHeight)
    final maxHeight = MediaQuery.of(context).size.height - 200;
    final height = cardHeight + (hourValue * duration.inHours);

    return height > maxHeight ? maxHeight : height;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          minimalVersion ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (!minimalVersion) _buildLeftBar(context),
        // card
        SizedBox(
          width: determineWidth(context, minimalVersion, padding),
          height: cardHeight,
          child: Card(
            shape: shape,
            color: cardColor(context),
            child: Column(
              children: [
                // color, name, tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // color, name
                    Row(
                      children: [
                        buildCircle(activity.color),
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
                    ActivityEmoji(
                      activity,
                      hideEmojiPicker: hideEmojiPicker,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        activity.goal == null
                            ? const SizedBox.shrink()
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
}
