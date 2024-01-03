import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../utils/constants.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final GoRouter _router;

  NavigationCubit(this._router) : super(const NavigationState());

  final List<Widget> pages = [
    const ActivitiesPage(),
    const HistoryPage(),
    const CircularProgressIndicator.adaptive(),
  ];

  void onDestinationSelected(int dest) {
    final destonation = AppNavigationDestination.values[dest];
    _router.goNamed(destonation.routeName);
    emit(state.copyWith(destination: destonation));
  }

  void onResize(BoxConstraints constraints) {
    if (constraints.maxWidth >= Constants.tabletWidth) {
      if (state.destination == AppNavigationDestination.history) {
        Future(() =>
            onDestinationSelected(AppNavigationDestination.activities.index));
      }
      emit(
        state.copyWith(
          disableHistoryDestination: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          disableHistoryDestination: false,
        ),
      );
    }
  }
}

class NavigationState extends Equatable {
  const NavigationState({
    this.destination = AppNavigationDestination.activities,
    this.disableHistoryDestination = false,
  });

  final AppNavigationDestination destination;
  final bool disableHistoryDestination;

  NavigationState copyWith({
    AppNavigationDestination? destination,
    bool? disableHistoryDestination,
  }) =>
      NavigationState(
        destination: destination ?? this.destination,
        disableHistoryDestination:
            disableHistoryDestination ?? this.disableHistoryDestination,
      );

  @override
  List<Object?> get props => [
        disableHistoryDestination,
        destination,
      ];
}

enum AppNavigationDestination {
  activities(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    routeName: '/',
  ),
  history(
    icon: Icon(Icons.history_outlined),
    selectedIcon: Icon(Icons.history_rounded),
    routeName: 'history',
  ),
  editActivities(
    icon: Icon(Icons.edit_note_outlined),
    selectedIcon: Icon(Icons.edit_note_rounded),
    routeName: 'card_editor',
  );

  final Icon icon;
  final Icon selectedIcon;
  final String routeName;

  String label(BuildContext context) => switch (this) {
        activities => AppLocalizations.of(context)!.activities,
        history => AppLocalizations.of(context)!.history,
        editActivities => AppLocalizations.of(context)!.editActivitiesShort,
      };

  const AppNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.routeName,
  });
}
