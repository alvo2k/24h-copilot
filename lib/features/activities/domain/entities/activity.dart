import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Activity extends Equatable {
  final int id;

  final String name;

  final Color color;

  final DateTime startTime;

  final List<String>? tags;

  final DateTime? endTime;

  final int? goal;

  final String? emoji;

  const Activity({
    required this.id,
    required this.name,
    required this.color,
    required this.startTime,
    this.tags,
    this.endTime,
    this.goal,
    this.emoji,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        startTime,
        tags,
        endTime,
        goal,
        emoji,
      ];
}
