import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/history/presentation/bloc/history_bloc.dart';
import '../../../features/history/presentation/bloc/search_suggestions_cubit.dart';
import 'activity_color.dart';
import 'activity_settings_card.dart';

class ActivitySearchBar extends StatefulWidget implements PreferredSizeWidget {
  const ActivitySearchBar({
    required this.title,
    this.showDatePicker = false,
    this.showEditMode = false,
    this.dropShadow = false,
    super.key,
  });

  final bool showDatePicker, dropShadow, showEditMode;
  final String title;

  @override
  State<ActivitySearchBar> createState() => _ActivitySearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ActivitySearchBarState extends State<ActivitySearchBar>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  final _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  late final AnimationController _textFieldAnimationController,
      _overlayAnimationController;
  late final Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();

    _textFieldAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _overlayAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _titleAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _textFieldAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus &&
          _overlayAnimationController.status == AnimationStatus.dismissed) {
        Future(() => _showOverlay(context));
      }
      if (!_textFieldFocusNode.hasFocus && _overlayEntry!.mounted) {
        _overlayAnimationController.reverse().whenCompleteOrCancel(() {
          _textFieldFocusNode.unfocus();
        });
        // requestFocus so that the text field has a focused border
        // until the end of the overlay animation
        _textFieldFocusNode.requestFocus();
        _textFieldFocusNode.consumeKeyboardToken();
      }
    });

    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && _textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.unfocus();
      }
    });
  }

  void _showOverlay(BuildContext context) {
    final overlayState = Overlay.of(context, rootOverlay: true);
    _disposeOverlay();

    final renderBox =
        _textFieldKey.currentContext!.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedSearchResults(
          leftPadding: offset.dx,
          animationController: _overlayAnimationController,
          width: renderBox.size.width,
          onTap: (activityName) => _onSuggestionTap(activityName),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
    _textFieldAnimationController
        .forward()
        .then((_) => _overlayAnimationController.forward());
  }

  void _disposeOverlay() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry!.remove();
      _overlayEntry!.dispose();
    }
  }

  void _onSuggestionTap(String activityName) {
    _hideSearchField();
    context.pushNamed(
      'activity_analytics',
      pathParameters: {'activity_name': activityName},
    );
  }

  void _hideSearchField() {
    setState(() {
      _overlayAnimationController.reverse().whenCompleteOrCancel(() {
        _disposeOverlay();
        _textFieldFocusNode.unfocus();
        _textFieldAnimationController.reverse().whenCompleteOrCancel(() {
          if (mounted) setState(() => _controller.clear());
        });
      });
    });
  }

  get _searchFiledHidden =>
      _textFieldAnimationController.status == AnimationStatus.dismissed;

  @override
  void dispose() {
    _textFieldAnimationController.dispose();
    _overlayAnimationController.dispose();
    _textFieldFocusNode.dispose();
    _controller.dispose();
    _disposeOverlay();

    super.dispose();
  }

  void _rangePicker(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate:
          context.read<HistoryBloc>().firstActivityDate ?? DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (range != null && mounted) {
      context.read<HistoryBloc>().add(
            HistoryLoad(
              range.start,
              range.end,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Theme.of(context).canvasColor,
      shadowColor:
          widget.dropShadow ? Theme.of(context).colorScheme.primary : null,
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          FadeTransition(
            opacity: _titleAnimation,
            child: Text(widget.title),
          ),
          if (!_searchFiledHidden)
            LayoutBuilder(
              builder: (context, constraints) {
                Future(() {
                  // notify the overlay of a size change
                  if (_overlayEntry?.mounted ?? false) {
                    _overlayEntry!.markNeedsBuild();
                  }
                });

                return AnimatedSearchField(
                  textFieldKey: _textFieldKey,
                  constraints: constraints,
                  controller: _controller,
                  animationController: _textFieldAnimationController,
                  focusNode: _textFieldFocusNode,
                  onArrowPress: _hideSearchField,
                  onClearPress: () => setState(() {
                    _controller.clear();
                    context.read<SearchSuggestionsCubit>().search('');
                  }),
                  onSubmitted: (_) {
                    final suggestions =
                        context.read<SearchSuggestionsCubit>().state;
                    if (suggestions.activities.isNotEmpty) {
                      _onSuggestionTap(suggestions.activities.first.name);

                      return;
                    } else if (suggestions.tags.isNotEmpty) {
                      // TODO add page for tags
                    }
                    _textFieldFocusNode.requestFocus();
                  },
                );
              },
            ),
        ],
      ),
      actions: [
        if (widget.showEditMode && _searchFiledHidden)
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/edit_mode.svg',
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
            tooltip: AppLocalizations.of(context)!.editMode,
            onPressed: () => BlocProvider.of<EditModeCubit>(context).toggle(),
          ),
        if (widget.showDatePicker && _searchFiledHidden)
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            tooltip: AppLocalizations.of(context)!.dateRange,
            onPressed: () => _rangePicker(context),
          ),
        if (_searchFiledHidden)
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context)!.searchActivitiesAndTags,
            onPressed: () => setState(() {
              context.read<SearchSuggestionsCubit>().search(_controller.text);

              _textFieldAnimationController
                  .forward()
                  .whenComplete(() => _textFieldFocusNode.requestFocus());
            }),
          ),
      ],
    );
  }
}

class AnimatedSearchResults extends StatelessWidget {
  const AnimatedSearchResults({
    super.key,
    required this.animationController,
    required this.width,
    this.onTap,
    this.leftPadding,
  });

  final AnimationController animationController;
  final double width;
  final void Function(String search)? onTap;
  final double? leftPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: leftPadding,
      top: kToolbarHeight + MediaQuery.of(context).viewPadding.top,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Material(
          color: Theme.of(context).cardColor,
          child: BlocBuilder<SearchSuggestionsCubit, SearchSuggestion>(
            builder: (context, searchSuggestions) {
              var resultLength = max(
                searchSuggestions.activities.length,
                searchSuggestions.tags.length,
              );
              resultLength = max(resultLength, 1);
              return AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => SizedBox(
                  width: width,
                  height: 30 * resultLength * animationController.value,
                  child: ListView.separated(
                    itemCount: resultLength,
                    itemBuilder: (context, index) => SearchSuggestionTile(
                      onTap: onTap,
                      width: width,
                      index: index,
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 4,
                      endIndent: 4,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SearchSuggestionTile extends StatelessWidget {
  const SearchSuggestionTile({
    super.key,
    required this.onTap,
    required this.width,
    required this.index,
  });

  final void Function(String search)? onTap;
  final double width;
  final int index;

  @override
  Widget build(BuildContext context) {
    final searchSuggestions = context.read<SearchSuggestionsCubit>().state;
    final isActivity = searchSuggestions.activities.isNotEmpty;
    return InkWell(
      onTap: isActivity
          ? () => onTap?.call(searchSuggestions.activities[index].name)
          : null,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        height: 30,
        color: index == 0
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).cardColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isActivity)
              ActivityColor(
                color: searchSuggestions.activities[index].color,
                padding: const EdgeInsets.only(right: 12),
              ),
            Text(
              isActivity
                  ? searchSuggestions.activities[index].name
                  : searchSuggestions.tags.elementAtOrNull(index) ??
                      AppLocalizations.of(context)!.searchNotFound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (isActivity)
              ActivityTags(
                  tags: searchSuggestions.activities[index].tags ?? []),
          ],
        ),
      ),
    );
  }
}

class AnimatedSearchField extends StatelessWidget {
  const AnimatedSearchField({
    super.key,
    required this.constraints,
    required this.controller,
    this.focusNode,
    required this.animationController,
    this.onArrowPress,
    this.onClearPress,
    this.onSubmitted,
    this.textFieldKey,
  });

  final BoxConstraints constraints;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final AnimationController animationController;
  final VoidCallback? onArrowPress;
  final VoidCallback? onClearPress;
  final void Function(String search)? onSubmitted;
  final Key? textFieldKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Align(
        alignment: Alignment.centerRight,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: kToolbarHeight,
          width: animationController.value * constraints.maxWidth,
          child: TextField(
            key: textFieldKey,
            focusNode: focusNode,
            controller: controller,
            onChanged: (search) =>
                context.read<SearchSuggestionsCubit>().search(search),
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              isDense: true,
              hintText:
                  AppLocalizations.of(context)!.searchActivitiesAndTagsPrompt,
              focusedBorder: OutlineInputBorder(
                borderSide: Theme.of(context)
                        .inputDecorationTheme
                        .focusedBorder
                        ?.borderSide ??
                    const BorderSide(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onArrowPress,
              ),
              suffixIcon: AnimatedBuilder(
                animation: controller,
                builder: (context, child) => IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: controller.text == '' ? null : onClearPress,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
