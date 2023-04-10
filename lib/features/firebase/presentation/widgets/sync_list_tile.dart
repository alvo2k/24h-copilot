import '../bloc/sync_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SyncListTile extends StatelessWidget {
  const SyncListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sync),
      title: Text(AppLocalizations.of(context)!.synchronization),
      onTap: () {
        BlocProvider.of<SyncCubit>(context).sync();
      },
    );
  }
}
