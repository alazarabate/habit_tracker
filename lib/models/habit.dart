class Habit {
  final String id;
  final String name;
  final bool isDone;
  final int streak;

  Habit({
    required this.id,
    required this.name,
    this.isDone = false,
    this.streak = 0,
  });

  Habit copyWith({bool? isDone, int? streak}) {
    return Habit(
      id: id,
      name: name,
      isDone: isDone ?? this.isDone,
      streak: streak ?? this.streak,
    );
  }
}