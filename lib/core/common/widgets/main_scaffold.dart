import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'common_drawer.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    const ActivitiesPage(),
    const DashboardPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _rangePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white70,
        // foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.activities),
        actions: [
          currentIndex == 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/edit_mode.svg',
                      color: Theme.of(context).primaryIconTheme.color,
                      width: 22,
                      height: 22,
                    ),
                    tooltip: AppLocalizations.of(context)!.editMode,
                    onPressed: () {
                      BlocProvider.of<EditModeCubit>(context).toggle();
                    },
                  ),
                )
              : const SizedBox.shrink(),
          currentIndex == 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: const Icon(Icons.date_range_outlined),
                    tooltip: AppLocalizations.of(context)!.dateRange,
                    onPressed: _rangePicker,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      drawer: const CommonDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.activities,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: AppLocalizations.of(context)!.dashboard,
          ),
        ],
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
      body: _pages.elementAt(currentIndex),
    );
  }
}
