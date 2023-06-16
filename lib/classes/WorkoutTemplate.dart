import '../DB/DBHelper.dart';
import 'Exercise.dart';

class WorkoutTemplate{
  String workoutName = '';
  List<Exercise> workoutExercises = [];
  List<int> sets;
  String date = '';

  WorkoutTemplate({required this.workoutName, required this.workoutExercises, required this.sets, required this.date});
}

Future<List<WorkoutTemplate>> fetchWorkouts() async {
  final exerciseMaps = await DBHelper.getWorkouts();

  Map<String, List<Map<String, dynamic>>> groupedWorkouts = {};

  for (var map in exerciseMaps) {
    String key = "${map['name']}_${map['date']}";
    if (!groupedWorkouts.containsKey(key)) {
      groupedWorkouts[key] = [map];
    } else {
      groupedWorkouts[key]?.add(map);
    }
  }

  List<WorkoutTemplate> workouts = [];

  for (var key in groupedWorkouts.keys) {
    List<int> sets = [];
    List<Exercise> workoutE = [];
    String name = '';
    String date = '';

    for (var map in groupedWorkouts[key]!) {
      name = map['workoutName'];
      workoutE = map['name'];
      date = map['date'];
      sets.add(map['sets']);
    }

    workouts.add(WorkoutTemplate(
      workoutName: name,
      workoutExercises: workoutE,
      sets: sets,
      date: date,
    ));
  }

  return workouts;
}