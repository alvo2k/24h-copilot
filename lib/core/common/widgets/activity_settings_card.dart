import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/common/activity_settings.dart';
import '../../../../core/common/widgets/activity_color.dart';
import '../../../../core/common/widgets/tag_chip.dart';
import '../../../../core/utils/extensions.dart';
import '../../../features/activities/presentation/widgets/activity_emoji.dart';
import '../../../features/activities/presentation/widgets/activity_time.dart';

class ActivitySettingsCard extends StatelessWidget {
  const ActivitySettingsCard({
    super.key,
    required this.name,
    required this.color,
    this.onPressed,
    this.tags,
    this.goal,
    this.goalReached,
    this.startTime,
    this.endTime,
    this.onEmojiSelected,
    this.emoji,
  });

  ActivitySettingsCard.fromActivitySettings(
    ActivitySettings settings, {
    bool? goalReached,
    void Function()? onPressed,
    void Function(String newEmoji)? onEmojiSelected,
    String? emoji,
    Key? key,
  }) : this(
          key: key,
          name: settings.name,
          color: settings.color,
          onPressed: onPressed,
          goal:
              settings.goal != null ? Duration(minutes: settings.goal!) : null,
          goalReached: goalReached,
          tags: settings.tags,
          onEmojiSelected: onEmojiSelected,
          emoji: emoji,
        );

  final String name;
  final Color color;
  final List<String>? tags;
  final Duration? goal;
  final bool? goalReached;
  final void Function()? onPressed;
  final DateTime? startTime;
  final DateTime? endTime;
  final void Function(String newEmoji)? onEmojiSelected;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(450, 125)),
      child: InkWell(
        onTap: onPressed,
        customBorder: Theme.of(context).cardTheme.shape,
        child: Card(
          color: goalReached ?? false
              ? Theme.of(context).cardColorGoalReached
              : Theme.of(context).cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // color, name, tags
              Row(
                children: [
                  ActivityColor(color: color),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (tags != null) _Tags(tags: tags!),
                ],
              ),
              // emoji, goal, time
              Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActivityEmoji(
                      emoji: emoji,
                      onEmojiSelected: onEmojiSelected,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (goal != null)
                          Text(
                            goal!.inHours > 0
                                ? AppLocalizations.of(context)!.timeFormat(
                                    AppLocalizations.of(context)!.goal,
                                    goal!.inHours,
                                    AppLocalizations.of(context)!.hourLetter,
                                    goal!.inMinutes - goal!.inHours * 60,
                                    AppLocalizations.of(context)!.minuteLetter,
                                  )
                                : AppLocalizations.of(context)!
                                    .timeFormatMinutes(
                                    AppLocalizations.of(context)!.goal,
                                    goal!.inMinutes,
                                    AppLocalizations.of(context)!.minuteLetter,
                                  ),
                          ),
                        if (startTime != null)
                          ActivityTime(
                            startTime: startTime!,
                            endTime: endTime,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tags extends StatefulWidget {
  const _Tags({required this.tags});

  final List<String> tags;

  @override
  State<_Tags> createState() => __TagsState();
}

class __TagsState extends State<_Tags> {
  final _tagController = ScrollController();
  bool fadeStart = false;
  bool fadeEnd = false;
  static const _fadeLength = 0.2;

  @override
  void initState() {
    super.initState();
    _tagController.addListener(_shader);
    WidgetsBinding.instance.addPostFrameCallback((_) => _shader());
  }

  @override
  void didUpdateWidget(covariant _Tags oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future(() => _shader());
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _shader() {
    if (!mounted) return;
    final position = _tagController.position;

    final prevFadeStart = fadeStart;
    final prevFadeEnd = fadeEnd;
    if (position.maxScrollExtent == position.pixels) {
      fadeEnd = false;
    } else {
      fadeEnd = true;
    }
    if (position.minScrollExtent == position.pixels) {
      fadeStart = false;
    } else {
      fadeStart = true;
    }
    if (prevFadeEnd != fadeEnd || prevFadeStart != fadeStart) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final fadeColor = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _tagController,
            thickness: Platform.isAndroid || Platform.isIOS ? 0 : 5,
            child: ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                tileMode: TileMode.mirror,
                colors: [
                  fadeColor,
                  Colors.transparent,
                  Colors.transparent,
                  fadeColor,
                ],
                stops: [
                  0.0,
                  fadeStart ? _fadeLength : 0.0,
                  fadeEnd ? 1.0 - _fadeLength : 1.0,
                  1.0
                ], // 10% purple, 80% transparent, 10% purple
              ).createShader(rect),
              blendMode: BlendMode.dstOut,
              child: SingleChildScrollView(
                controller: _tagController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: max(constraints.maxWidth, 150),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      widget.tags.length,
                      (index) => TagChip(tag: widget.tags[index]),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
