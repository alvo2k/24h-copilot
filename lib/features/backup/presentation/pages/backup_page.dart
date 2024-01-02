import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../cubit/backup_cubit.dart';
import '../widgets/backup_button.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  static Future<bool> onExit(BuildContext context) async {
    if (context.read<BackupCubit>().state.status == BackupStatus.imported &&
        (Platform.isAndroid || Platform.isIOS)) {
      Restart.restartApp();
    }
    return true;
  }

  void showStatusSnackBar(BackupState state, BuildContext context) {
    switch (state.status) {
      case BackupStatus.exporting:
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            message: AppLocalizations.of(context)!.exporting,
          ),
          persistent: true,
        );
        break;
      case BackupStatus.importing:
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.info(
            message: AppLocalizations.of(context)!.importing,
          ),
          persistent: true,
        );
        break;
      case BackupStatus.exported:
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message:
                AppLocalizations.of(context)!.downloadedTo(state.exportedPath),
          ),
        );
        break;
      case BackupStatus.imported:
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: AppLocalizations.of(context)!.imported,
          ),
        );
        break;
      case BackupStatus.failure:
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: state.failure!.localize(context),
          ),
        );
        break;
      case BackupStatus.initial:
        break;
    }
  }

  void confirmImportDialog(BuildContext context, File file) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(AppLocalizations.of(context)!.confirmUpload),
          content: Text(
              '${AppLocalizations.of(context)!.dataWillBeLost}\n\n${AppLocalizations.of(context)!.areYouSure}'),
          actions: [
            BasicDialogAction(
              onPressed: () {
                context.read<BackupCubit>().import(file);
                context.pop();
              },
              iosIsDestructiveAction: true,
              title: Text(
                AppLocalizations.of(context)!.confirmOverride,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.red),
              ),
            ),
            BasicDialogAction(
              onPressed: context.pop,
              title: Text(
                AppLocalizations.of(context)!.cancel,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageData),
      ),
      body: BlocListener<BackupCubit, BackupState>(
        listener: (context, state) => showStatusSnackBar(state, context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackupButton(
                  text: AppLocalizations.of(context)!.export,
                  picture: SvgPicture.asset('assets/icons/export.svg'),
                  onTap: () => context.read<BackupCubit>().export(),
                ),
                const SizedBox(height: 32),
                BackupButton(
                  text: AppLocalizations.of(context)!.import,
                  picture: SvgPicture.asset('assets/icons/import.svg'),
                  onTap: () async {
                    final filePicked = await FilePicker.platform.pickFiles();

                    if (filePicked != null) {
                      final file = File(filePicked.files.single.path!);
                      if (context.mounted) confirmImportDialog(context, file);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
