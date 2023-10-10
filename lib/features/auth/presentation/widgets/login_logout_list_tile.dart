import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';
import '../pages/auth_page.dart';

class LoginLogOutListTile extends StatelessWidget {
  const LoginLogOutListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => switch (state) {
        Loading() => ListTile(
            leading: const CircularProgressIndicator.adaptive(),
            title: Text(AppLocalizations.of(context)!.loading),
          ),
        LoggedIn() => ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              // BlocProvider.of<AuthBloc>(context).add(AuthEvent.signOut());
            },
          ),
        LoggedOut() => ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.loginRegistration),
            onTap: () {
              // navigate to the login/registration page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthPage(),
                ),
              );
            },
          ),
        NoInternet() => ListTile(
            leading: const Icon(Icons.error),
            title: Text(AppLocalizations.of(context)!.noInternet),
            subtitle: Text(AppLocalizations.of(context)!.checkConnection),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
