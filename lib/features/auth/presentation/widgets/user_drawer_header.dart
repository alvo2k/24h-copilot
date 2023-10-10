import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';

class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<AuthBloc>(context).add(AuthEvent.getUserData());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => switch(state) {
        LoggedIn() => UserAccountsDrawerHeader(
          accountName: Text(state.displayName ?? ''),
          accountEmail: Text(state.email),
        ),
        NoInternet() => DrawerHeader(
          child: Text(AppLocalizations.of(context)!.noInternet),
        ),
        _ => const SizedBox.shrink(),
      }
    );
  }
}
