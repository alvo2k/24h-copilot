import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/presentation/bloc/search_suggestions_cubit.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'common_drawer.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;
  final dashbordSearchTo = DateTime.now();
  final dashbordSearchFrom = DateTime.now().subtract(const Duration(days: 30));

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
    final searchCubit = BlocProvider.of<SearchSuggestionsCubit>(context);
    return Scaffold(
      appBar: EasySearchBar(
        asyncSuggestions: (val) async {
          await searchCubit.search(val);
          return searchCubit.state;
        },
        title: Text(AppLocalizations.of(context)!.activities),
        onSearch: (_) {},
        onSuggestionTap: (search) {
          setState(() {
            currentIndex = 1; // goto dashboard page
          });
          BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(
            dashbordSearchFrom,
            dashbordSearchTo,
            search,
          ));
          print('tap: $search');
        },
        actions: [
          currentIndex == 0
              ? IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/edit_mode.svg',
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  tooltip: AppLocalizations.of(context)!.editMode,
                  onPressed: () {
                    BlocProvider.of<EditModeCubit>(context).toggle();
                  },
                )
              : const SizedBox.shrink(),
          currentIndex == 1
              ? IconButton(
                  icon: const Icon(Icons.date_range_outlined),
                  tooltip: AppLocalizations.of(context)!.dateRange,
                  onPressed: _rangePicker,
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
