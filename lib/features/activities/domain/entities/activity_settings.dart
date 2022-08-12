part of 'activity.dart';

class ActivitySettings extends Equatable {
  const ActivitySettings({required this.name, this.tags, this.goal, required this.color});

  final Color color;
  final int? goal;
  final String name;
  final List<String>? tags;

  @override
  List<Object?> get props => [
        name,
        color,
        tags,
        goal,
      ];
}
