import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../common/bloc/home_screen_cubit.dart';
import '../../common/widgets/activity_search_bar.dart';
import '../../common/widgets/common_drawer.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) => Scaffold(
        appBar: buildSearchAppbar(
          context,
          actionButtons: [
            state.selectedIndex == 0
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
                    onPressed: () =>
                        context.read<HomeScreenCubit>().rangePicker(context),
                  ),
          ],
          onSuggestionTap: (search) =>
              context.read<HomeScreenCubit>().onSuggestionTap(context, search),
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
          currentIndex: state.selectedIndex,
          onTap: (int dest) => context
              .read<HomeScreenCubit>()
              .onDestinationSelected(dest, context),
        ),
        body: context
            .read<HomeScreenCubit>()
            .pages
            .elementAt(state.selectedIndex),
      ),
    );
  }
}
