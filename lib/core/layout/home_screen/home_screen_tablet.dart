import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../common/widgets/activity_search_bar.dart';
import '../../common/widgets/navigation_rail.dart';

class HomeScreenTablet extends StatefulWidget {
  const HomeScreenTablet({super.key});

  @override
  State<HomeScreenTablet> createState() => _HomeScreenTabletState();
}

class _HomeScreenTabletState extends State<HomeScreenTablet> {
  int currentIndex = 0;
  final dashbordSearchFrom = DateTime.now().subtract(const Duration(days: 30));
  final dashbordSearchTo = DateTime.now();
  DateTime? firstDate;

  void _rangePicker() {
    showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime.now(),
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

  final List<Widget> _pages = [
    const ActivitiesPage(),
    const DashboardPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    if (dashboardBloc.state is DashboardInitial) {
      (dashboardBloc.state as DashboardInitial)
          .firstRecordDate
          .then((date) => setState(() => firstDate = date));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchAppbar(
        context,
        actionButtons: [
          currentIndex == 0
              ? IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/edit_mode.svg',
                    alignment: Alignment.bottomRight,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                  tooltip: AppLocalizations.of(context)!.editMode,
                  onPressed: () =>
                      BlocProvider.of<EditModeCubit>(context).toggle(),
                )
              : IconButton(
                  icon: const Icon(Icons.date_range_outlined),
                  tooltip: AppLocalizations.of(context)!.dateRange,
                  onPressed: _rangePicker,
                ),
        ],
        onSuggestionTap: (search) {
          setState(() {
            currentIndex = 1; // goto dashboard page
          });
          BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(
            dashbordSearchFrom,
            dashbordSearchTo,
            search,
          ));
        },
      ),
      body: Row(
        children: [
          NavigatorRail(onItemSelected: _onItemTapped),
          const VerticalDivider(),
          Expanded(child: _pages.elementAt(currentIndex)),
        ],
      ),
    );
  }
}
