import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier() : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString('habits');
    if (habitsString != null) {
      final List<dynamic> habitsJson = json.decode(habitsString);
      state = habitsJson.map((json) => Habit(
        id: json['id'],
        name: json['name'],
        isDone: json['isDone'],
        streak: json['streak'],
      )).toList();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = state.map((habit) => {
      'id': habit.id,
      'name': habit.name,
      'isDone': habit.isDone,
      'streak': habit.streak,
    }).toList();
    await prefs.setString('habits', json.encode(habitsJson));
  }

  void addHabit(String name) {
    final newHabit = Habit(id: DateTime.now().toString(), name: name);
    state = [...state, newHabit];
    _saveHabits();
  }

  void toggleDone(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          habit.copyWith(
            isDone: !habit.isDone,
            streak: !habit.isDone ? habit.streak + 1 : habit.streak,
          )
        else
          habit,
    ];
    _saveHabits();
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier();
});