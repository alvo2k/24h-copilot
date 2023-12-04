import 'package:equatable/equatable.dart';

import '../../../../core/common/activity_settings.dart';

class HeatMapData extends Equatable {
  const HeatMapData(this.activity, this.dataset);

  final ActivitySettings activity;

  final Map<DateTime, int>? dataset;

  @override
  List<Object?> get props => [activity, dataset];
}
