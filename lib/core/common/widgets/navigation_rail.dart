import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../bloc/navigation_cubit.dart';
import '../bloc/theame_cubit.dart';

class NavigatorRail extends StatelessWidget {
  const NavigatorRail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) => NavigationRail(
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: Text(AppLocalizations.of(context)!.activities),
          ),
          if (!state.hideHistoryestination)
            NavigationRailDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history_rounded),
              label: Text(AppLocalizations.of(context)!.history),
            ),
          NavigationRailDestination(
            icon: const Icon(Icons.edit_outlined),
            selectedIcon: const Icon(Icons.edit_rounded),
            label: Text(AppLocalizations.of(context)!.editActivitiesShort),
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
                  onPressed: () => context.pushNamed('backup'),
                  icon: const Icon(Icons.import_export),
                  tooltip: AppLocalizations.of(context)!.backup,
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
        selectedIndex: state.navRailIndex,
        onDestinationSelected: (int index) =>
            context.read<NavigationCubit>().onDestinationSelected(index),
      ),
    );
  }
}
