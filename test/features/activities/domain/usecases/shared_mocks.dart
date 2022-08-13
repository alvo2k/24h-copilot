import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ActivityRepository])
export 'shared_mocks.mocks.dart';

final Activity tActivity = Activity(
  recordId: 1,
  name: 'name',
  color: Colors.black,
  startTime: DateTime(1),
);
