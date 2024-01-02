import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class Failure extends Equatable {
  Failure({
    this.type = FailureType.unknown,
    this.reportToSenty = false,
    this.extra,
  }) {
    if (reportToSenty) {
      Sentry.captureMessage(toString(), params: [StackTrace.current]);
    }
    debugPrint(toString());
  }

  final FailureType type;
  final dynamic extra;
  final bool reportToSenty;

  @override
  String toString() => '''
Failure(
  type: $type,
  extra: $extra,
)''';

  @override
  List<Object> get props => [type, extra, reportToSenty];
}

class Success extends Equatable {
  const Success([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object> get props => [properties];
}

enum FailureType {
  unknown,
  localStorage,
  unreachableFolder;

  String localize(BuildContext context) => switch (this) {
        FailureType.unknown => AppLocalizations.of(context)!.somethingWentWrong,
        FailureType.localStorage =>
          AppLocalizations.of(context)!.somethingWrongWithLocalStorage,
        FailureType.unreachableFolder =>
          AppLocalizations.of(context)!.unreachableFolder,
      };
}
