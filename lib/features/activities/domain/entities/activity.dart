import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Activity extends Equatable {
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

  final Color color;
  final String? emoji;
  final DateTime? endTime;
  final int? goal;
  final int id;
  final String name;
  final DateTime startTime;
  final List<String>? tags;

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
