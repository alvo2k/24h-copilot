import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scaled_app/scaled_app.dart';

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

  static const cardHeight = 125.0;

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

  static double determineWidth(
    double maxWidth,
    bool minimalVersion, [
    double padding = 76,
  ]) {
    var preferredWidth = 500.0;
    if (minimalVersion) {
      preferredWidth = maxWidth - padding > preferredWidth
          ? preferredWidth
          : maxWidth - padding;
    }
    return maxWidth > preferredWidth
        ? preferredWidth - _leftPadding - _leftBarWidth - _rightPadding
        : maxWidth - _leftPadding - _leftBarWidth - _rightPadding;
  }

  static Color cardColor(BuildContext context, [Activity? activity]) {
    if (activity != null && activity.goal != null) {
      final duration = (activity.endTime ?? DateTime.now())
          .difference(activity.startTime)
          .inMinutes;
      if (duration >= activity.goal!) {
        return Theme.of(context).brightness == Brightness.light
            ? const Color.fromRGBO(193, 232, 197, 1)
            : Colors.green[900]!;
      }
    }
    return Theme.of(context).cardColor;
  }

  static ShapeBorder get shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

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

  static Widget buildGoal(int goal, BuildContext context) {
    final hours = goal ~/ 60;
    if (hours > 0) {
      return Text(AppLocalizations.of(context)!.timeFormat(
        AppLocalizations.of(context)!.goal,
        hours,
        AppLocalizations.of(context)!.hourLetter,
        goal - hours * 60,
        AppLocalizations.of(context)!.minuteLetter,
      ));
    } else {
      return Text(AppLocalizations.of(context)!.timeFormatMinutes(
        AppLocalizations.of(context)!.goal,
        goal,
        AppLocalizations.of(context)!.minuteLetter,
      ));
    }
  }

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
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            minimalVersion ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (!minimalVersion) _buildLeftBar(context),
          // card
          SizedBox(
            width: determineWidth(
              constraints.maxWidth,
              minimalVersion,
              padding,
            ),
            height: cardHeight,
            child: Card(
              shape: shape,
              color: cardColor(context, activity),
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
                                  children:
                                      buildTags(activity.tags ?? [], context),
                                ),
                              ),
                            );
                          },
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            activity.goal == null
                                ? const SizedBox.shrink()
                                : buildGoal(activity.goal!, context),
                            ActivityTime(
                              startTime: activity.startTime,
                              endTime: activity.endTime,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
