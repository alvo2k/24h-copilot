import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/theame_cubit.dart';

class NavigatorRail extends StatefulWidget {
  const NavigatorRail({
    required this.onItemSelected,
    this.hideAnalyticsDestination = false,
    super.key,
  });

  final void Function(int) onItemSelected;
  final bool hideAnalyticsDestination;

  @override
  State<NavigatorRail> createState() => _NavigatorRailState();
}

class _NavigatorRailState extends State<NavigatorRail> {
  int currentIndex = 0;

  void onItemSelected(int item) {
    setState(() {
      currentIndex = item;
    });
    widget.onItemSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(AppLocalizations.of(context)!.activities),
        ),
        if (!widget.hideAnalyticsDestination)
          NavigationRailDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: Text(AppLocalizations.of(context)!.dashboard),
          ),
        const NavigationRailDestination(
          icon: Icon(Icons.edit_outlined),
          selectedIcon: Icon(Icons.edit),
          label: Text(
              'Edit'), // TODO: AppLocalizations.of(context)!.editActivitiesShort
        ),
      ],
      trailing: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sync),
                tooltip: AppLocalizations.of(context)!.synchronization,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star),
                tooltip: AppLocalizations.of(context)!.rateTheApp,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.feedback),
                tooltip: AppLocalizations.of(context)!.feedback,
              ),
              IconButton(
                onPressed: () {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    BlocProvider.of<ThemeCubit>(context)
                        .setTheme(ThemeMode.light);
                  } else {
                    BlocProvider.of<ThemeCubit>(context)
                        .setTheme(ThemeMode.dark);
                  }
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode_outlined),
                tooltip: AppLocalizations.of(context)!.theme,
              ),
            ],
          ),
        ),
      ),
      selectedIndex: currentIndex,
      onDestinationSelected: onItemSelected,
    );
  }
}
