import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/activities/presentation/pages/activities_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../common/bloc/home_screen_cubit.dart';
import '../../common/widgets/activity_search_bar.dart';
import '../../common/widgets/navigation_rail.dart';

class HomeScreenDesktop extends StatelessWidget {
  const HomeScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchAppbar(
        context,
        actionButtons: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/edit_mode.svg',
              alignment: Alignment.bottomRight,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
            tooltip: AppLocalizations.of(context)!.editMode,
            onPressed: () => BlocProvider.of<EditModeCubit>(context).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            tooltip: AppLocalizations.of(context)!.dateRange,
            onPressed: () => context.read<HomeScreenCubit>().rangePicker,
          )
        ],
        onSuggestionTap: (search) =>
            context.read<HomeScreenCubit>().onSuggestionTap(context, search),
      ),
      body: const Row(
        children: [
          NavigatorRail(),
          VerticalDivider(),
          Expanded(child: ActivitiesPage()),
          VerticalDivider(),
          Expanded(child: DashboardPage()),
        ],
      ),
    );
  }
}
