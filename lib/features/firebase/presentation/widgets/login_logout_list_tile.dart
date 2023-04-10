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
      builder: (context, state) => state.join(
        (initial) => const SizedBox.shrink(),
        (failure) => const SizedBox.shrink(),
        (loading) => const ListTile(
          leading: CircularProgressIndicator.adaptive(),
          title: Text('Loading...'),
        ),
        (loggedIn) => ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Log Out'),
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(AuthEvent.signOut());
          },
        ),
        (loggedOut) => ListTile(
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
        (noInternet) => const ListTile(
          leading: Icon(Icons.error),
          title: Text('No Internet Connection'),
          subtitle:
              Text('Please check your internet connection and try again.'),
        ),
      ),
    );
  }
}
