import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/dashboard/presentation/bloc/search_suggestions_cubit.dart';

buildSearchAppbar(
  BuildContext context, {
  required List<Widget> actionButtons,
  required dynamic Function(String) onSuggestionTap,
}) {
  return EasySearchBar(
    asyncSuggestions: (val) async {
      final searchCubit = BlocProvider.of<SearchSuggestionsCubit>(context);
      await searchCubit.search(val);
      return searchCubit.state;
    },
    title: Text(AppLocalizations.of(context)!.activities),
    onSearch: (_) {},
    onSuggestionTap: onSuggestionTap,
    actions: actionButtons,
  );
}

class ActivitySearchBar extends StatefulWidget implements PreferredSizeWidget {
  const ActivitySearchBar({super.key});

  @override
  State<ActivitySearchBar> createState() => _ActivitySearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ActivitySearchBarState extends State<ActivitySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
