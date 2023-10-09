import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../app_router.dart';
import '../../utils/constants.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final AppRouter _router;

  NavigationCubit(this._router)
      : super(NavigationState(
          bottomNavBarIndex: 0,
          hideDashboardDestination: false,
        ));

  final List<Widget> pages = [
    const ActivitiesPage(),
    const DashboardPage(),
    const CircularProgressIndicator.adaptive(),
  ];

  final _dashbordSearchFrom = DateTime.now().subtract(const Duration(days: 30));
  final _dashbordSearchTo = DateTime.now();
  DateTime? _dateOfFirstActivity;

  void getFirstDate(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    if (dashboardBloc.state is DashboardInitial) {
      (dashboardBloc.state as DashboardInitial)
          .firstRecordDate
          .then((date) => _dateOfFirstActivity = date);
    }
  }

  void onDestinationSelected(int dest, BuildContext context) {
    if (dest == 1 && state.hideDashboardDestination ||
        !state.hideDashboardDestination && dest == 2) {
      _router.go('/card_editor');
    } else if (dest == 1) {
      _router.go('/dashboard');
    } else {
      _router.go('/');
    }
  }

  void onSuggestionTap(BuildContext context, String search) {
    onDestinationSelected(1, context);

    BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(
      _dashbordSearchFrom,
      _dashbordSearchTo,
      search,
    ));
  }

  int _mapUriToBottomNavBarIndex() {
    final uri =
        _router.router.routerDelegate.currentConfiguration.uri.toString();

    if (uri.startsWith('/card_editor')) {
      return 0;
    }

    return switch (uri) {
      '/' => 0,
      '/dashboard' => 1,
      _ => throw Exception(
          'Unknown URI: $uri',
        ),
    };
  }

  int _mapUriToNavRailIndex({bool? hideDashboardDestination}) {
    final uri =
        _router.router.routerDelegate.currentConfiguration.uri.toString();

    if (uri.startsWith('/card_editor')) {
      return hideDashboardDestination ?? state.hideDashboardDestination ? 1 : 2;
    }

    return switch (uri) {
      '/' => 0,
      '/dashboard' =>
        hideDashboardDestination ?? state.hideDashboardDestination ? 0 : 1,
      _ => throw Exception(
          'Unknown URI: $uri',
        ),
    };
  }

  void onResize(BoxConstraints constraints) {
    if (constraints.maxWidth >= Constants.tabletWidth) {
      emit(
        state.copyWith(
          hideDashboardDestination: true,
          navRailIndex: _mapUriToNavRailIndex(hideDashboardDestination: true),
        ),
      );
    } else if (constraints.maxWidth >= Constants.mobileWidth) {
      emit(
        state.copyWith(
          hideDashboardDestination: false,
          navRailIndex: _mapUriToNavRailIndex(hideDashboardDestination: false),
        ),
      );
    } else {
      emit(
        state.copyWith(
          hideDashboardDestination: false,
          bottomNavBarIndex: _mapUriToBottomNavBarIndex(),
          navRailIndex: _mapUriToNavRailIndex(hideDashboardDestination: false),
        ),
      );
    }
  }

  void rangePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: _dateOfFirstActivity ?? DateTime.now(),
      lastDate: DateTime.now(),
    ).then((range) {
      if (range != null) {
        BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(
          range.start,
          range.end,
        ));
      }
    });
  }
}

class NavigationState {
  NavigationState({
    this.bottomNavBarIndex = 0,
    this.navRailIndex = 0,
    required this.hideDashboardDestination,
  });

  final bool hideDashboardDestination;
  final int bottomNavBarIndex;
  final int navRailIndex;

  NavigationState copyWith({
    int? bottomNavBarIndex,
    int? navRailIndex,
    bool? hideDashboardDestination,
  }) =>
      NavigationState(
        bottomNavBarIndex: bottomNavBarIndex ?? this.bottomNavBarIndex,
        hideDashboardDestination:
            hideDashboardDestination ?? this.hideDashboardDestination,
        navRailIndex: navRailIndex ?? this.navRailIndex,
      );
}
