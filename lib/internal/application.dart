import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/common/bloc/navigation_cubit.dart';
import '../core/common/bloc/theame_cubit.dart';
import '../core/utils/themes.dart';
import '../features/activities/presentation/bloc/activities_bloc.dart';
import '../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../features/activity_analytics/presentation/bloc/activity_analytics_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/card-editor/presentation/bloc/card_editor_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/bloc/search_suggestions_cubit.dart';
import 'injectable.dart';

class CopilotApp extends StatelessWidget {
  const CopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit()..loadSavedTheme(),
        ),
        BlocProvider(create: (_) => EditModeCubit()),
        BlocProvider(
          create: (context) => ActivitiesBloc(
            loadActivitiesUsecase: sl(),
            switchActivityUsecase: sl(),
            addEmojiUsecase: sl(),
            editNameUsecase: sl(),
            editRecordsUsecase: sl(),
            recommendedActivitiesUsecase: sl(),
          )..add(LoadActivities(DateUtils.dateOnly(DateTime.now()))),
        ),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => DashboardBloc(sl())),
        BlocProvider(create: (context) => CardEditorBloc(sl(), sl())),
        BlocProvider(create: (context) => SearchSuggestionsCubit(sl())),
        BlocProvider(create: (context) => ActivityAnalyticsBloc(sl())),
        BlocProvider(
          create: (context) => NavigationCubit(sl())..getFirstDate(context),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: sl<GoRouter>(),
            debugShowCheckedModeBanner: false,
            title: 'Copilot',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
