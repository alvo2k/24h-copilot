import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../utils/constants.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final GoRouter _router;

  NavigationCubit(this._router)
      : super(const NavigationState(
          bottomNavBarIndex: 0,
          hideHistoryestination: false,
        ));

  final List<Widget> pages = [
    const ActivitiesPage(),
    const HistoryPage(),
    const CircularProgressIndicator.adaptive(),
  ];

  void onDestinationSelected(int dest) {
    if (dest == 1 && state.hideHistoryestination ||
        !state.hideHistoryestination && dest == 2) {
      _router.go('/card_editor');
    } else if (dest == 1) {
      _router.go('/history');
    } else {
      _router.go('/');
    }
  }

  void onSuggestionTap(String search) {
    _router.pushNamed(
      'activity_analytics',
      pathParameters: {'activity_name': search},
    );
  }

  int _mapUriToBottomNavBarIndex() {
    final uri = _router.routerDelegate.currentConfiguration.uri.toString();

    if (uri.startsWith('/card_editor')) {
      return 0;
    }

    return switch (uri) {
      '/' => 0,
      '/history' => 1,
      _ => throw Exception(
          'Unknown URI: $uri',
        ),
    };
  }

  int _mapUriToNavRailIndex({bool? hideHistoryDestination}) {
    final uri = _router.routerDelegate.currentConfiguration.uri.toString();

    if (uri.startsWith('/card_editor')) {
      return hideHistoryDestination ?? state.hideHistoryestination ? 1 : 2;
    } else if (uri.startsWith('/activity_analytics')) {
      return hideHistoryDestination ?? state.hideHistoryestination ? 0 : 1;
    }

    return switch (uri) {
      '/' => 0,
      '/history' =>
        hideHistoryDestination ?? state.hideHistoryestination ? 0 : 1,
      _ => throw Exception(
          'Unknown URI: $uri',
        ),
    };
  }

  void onResize(BoxConstraints constraints) {
    if (constraints.maxWidth >= Constants.tabletWidth) {
      emit(
        state.copyWith(
          hideHistoryDestination: true,
          navRailIndex: _mapUriToNavRailIndex(hideHistoryDestination: true),
        ),
      );
    } else if (constraints.maxWidth >= Constants.mobileWidth) {
      emit(
        state.copyWith(
          hideHistoryDestination: false,
          navRailIndex: _mapUriToNavRailIndex(hideHistoryDestination: false),
        ),
      );
    } else {
      emit(
        state.copyWith(
          hideHistoryDestination: false,
          bottomNavBarIndex: _mapUriToBottomNavBarIndex(),
          navRailIndex: _mapUriToNavRailIndex(hideHistoryDestination: false),
        ),
      );
    }
  }
}

class NavigationState extends Equatable {
  const NavigationState({
    this.bottomNavBarIndex = 0,
    this.navRailIndex = 0,
    required this.hideHistoryestination,
  });

  final bool hideHistoryestination;
  final int bottomNavBarIndex;
  final int navRailIndex;

  NavigationState copyWith({
    int? bottomNavBarIndex,
    int? navRailIndex,
    bool? hideHistoryDestination,
  }) =>
      NavigationState(
        bottomNavBarIndex: bottomNavBarIndex ?? this.bottomNavBarIndex,
        hideHistoryestination:
            hideHistoryDestination ?? this.hideHistoryestination,
        navRailIndex: navRailIndex ?? this.navRailIndex,
      );

  @override
  List<Object?> get props => [
        hideHistoryestination,
        bottomNavBarIndex,
        navRailIndex,
      ];
}
