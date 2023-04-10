import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthEvent.getUserData());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => state.join(
        (initial) => const SizedBox.shrink(),
        (failure) {
          return const SizedBox.shrink();
        },
        (loading) => const SizedBox.shrink(),
        (loggedIn) => UserAccountsDrawerHeader(
          accountName: Text(loggedIn.displayName ?? ''),
          accountEmail: Text(loggedIn.email),
        ),
        (loggedOut) => const SizedBox.shrink(),
        (noInternet) => const DrawerHeader(
          child: Text('No internet'),
        ),
      ),
    );
  }
}
