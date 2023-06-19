import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/timerService.dart';

import 'Exercise.dart';

class ActiveWorkoutState with ChangeNotifier {
  TimerService timerService = TimerService();
  bool isActive = false;
  List<Exercise> activeExercises = [];
  String workoutName = "Active Workout";

  bool get getIsActive => isActive;

  void startWorkout() {
    isActive = true;
    timerService.startTimer();
    notifyListeners();
  }

  void endWorkout() {
    isActive = false;
    timerService.stopTimer();
    timerService.resetCounter();
    activeExercises.clear();
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    activeExercises.add(exercise);
    notifyListeners();
  }

  void updateExercise(int index, Exercise exercise) {
    activeExercises[index] = exercise;
    notifyListeners();
  }
}
