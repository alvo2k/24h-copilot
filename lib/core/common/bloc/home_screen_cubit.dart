import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../layout/card_editor/card_editor.dart';
import '../../layout/home_screen/home_screen.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit()
      : super(HomeScreenState(
          selectedIndex: 0,
          hideAnalyticsDestination: false,
        ));

  final List<Widget> pages = [
    const ActivitiesPage(),
    const DashboardPage(),
    const CircularProgressIndicator.adaptive(),
  ];

  final _dashbordSearchFrom = DateTime.now().subtract(const Duration(days: 30));
  final _dashbordSearchTo = DateTime.now();
  DateTime? _dateOfFirstActivity;
  late bool _isMobileLayout;

  void isMobileLayout(bool isMobileLayout) => _isMobileLayout = isMobileLayout;

  void navigateTo(Widget path, context) {
    if (_isMobileLayout) {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => path,
      ));
    } else {
      Navigator.of(context).pushAndRemoveUntil<void>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => path,
        ),
        (route) => false,
      );
    }
  }

  void getFirstDate(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    if (dashboardBloc.state is DashboardInitial) {
      (dashboardBloc.state as DashboardInitial)
          .firstRecordDate
          .then((date) => _dateOfFirstActivity = date);
    }
  }

  void onDestinationSelected(int dest, BuildContext context) {
    if (dest == 1 && state.hideAnalyticsDestination ||
        !state.hideAnalyticsDestination && dest == 2) {
      navigateTo(const CardEditorScreen(), context);
    } else {
      navigateTo(const HomeScreen(), context);
    }
    emit(state.copyWith(selectedIndex: dest));
  }

  void onSuggestionTap(BuildContext context, String search) {
    onDestinationSelected(1, context);
    BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(
      _dashbordSearchFrom,
      _dashbordSearchTo,
      search,
    ));
  }

  void hideAnalyticsDestination() =>
      emit(state.copyWith(hideAnalyticsDestination: true));

  void showAnalyticsDestination() =>
      emit(state.copyWith(hideAnalyticsDestination: false));

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

class HomeScreenState {
  HomeScreenState({
    this.selectedIndex = 0,
    required this.hideAnalyticsDestination,
  });

  final bool hideAnalyticsDestination;
  final int selectedIndex;

  HomeScreenState copyWith({
    int? selectedIndex,
    bool? hideAnalyticsDestination,
  }) =>
      HomeScreenState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        hideAnalyticsDestination:
            hideAnalyticsDestination ?? this.hideAnalyticsDestination,
      );
}
