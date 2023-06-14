import 'Exercise.dart';

class WorkoutTemplate{
  String workoutName = '';
  List<Exercise> workoutExercises = [];

  WorkoutTemplate({required this.workoutName, required this.workoutExercises, required String date, required List sets});

  String getName() {
    return workoutName;
  }
}