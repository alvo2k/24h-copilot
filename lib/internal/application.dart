import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/common/bloc/theame_cubit.dart';
import '../core/common/widgets/main_scaffold.dart';
import '../core/utils/themes.dart';
import '../features/activities/presentation/bloc/activities_bloc.dart';
import '../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../features/card-editor/presentation/bloc/card_editor_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/bloc/search_suggestions_cubit.dart';
import '../features/firebase/presentation/bloc/auth_bloc.dart';
import 'injectable.dart';

class CopilotApp extends StatefulWidget {
  const CopilotApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<CopilotApp> createState() => _CopilotAppState();
}

class _CopilotAppState extends State<CopilotApp> {
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
          )..add(ActivitiesEvent.loadActivities(
              DateUtils.dateOnly(DateTime.now()))),
        ),
        BlocProvider(create: (context) => AuthBloc(sl())),
        BlocProvider(create: (context) => DashboardBloc(sl())),
        BlocProvider(create: (context) => CardEditorBloc(sl(), sl())),
        BlocProvider(create: (context) => SearchSuggestionsCubit(sl())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: CopilotApp.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Copilot',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}
