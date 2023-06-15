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
    String key = "${map['workoutName']}_${map['date']}";
    if (!groupedWorkouts.containsKey(key)) {
      groupedWorkouts[key] = [map];
    } else {
      groupedWorkouts[key]?.add(map);
    }
  }

  List<WorkoutTemplate> workouts = [];

  for (var key in groupedWorkouts.keys) {
    List<int> sets = [];
    List<Exercise> workoutExercises = [];
    String workoutName = '';
    String date = '';

    for (var map in groupedWorkouts[key]!) {
      workoutName = map['workoutName'];
      Exercise exercise = Exercise(name: map['name']);
      workoutExercises.add(exercise);
      date = map['date'];
      sets.add(map['sets']);
    }

    workouts.add(
      WorkoutTemplate(
        workoutName: workoutName,
        workoutExercises: workoutExercises,
        sets: sets,
        date: date,
      ),
    );
  }
  print('HALOOOO: ${workouts[0].workoutExercises}');
  return workouts;
}
Future<List<WorkoutTemplate>> convertToWorkoutTemplates() async {
  List<Map<String, dynamic>> workoutMaps = await DBHelper.getWorkouts();
  List<WorkoutTemplate> workoutTemplates = [];

  for (var workoutMap in workoutMaps) {
    String workoutName = workoutMap['workoutName'];
    String exercisesString = workoutMap['exercises'];
    String setsString = workoutMap['sets'];
    String date = workoutMap['date'];

    List<String> exerciseNames = exercisesString.split(',');
    List<int> sets = setsString.split(',').map(int.parse).toList();

    List<Exercise> exercises = [];
    for (int i = 0; i < exerciseNames.length; i++) {
      String exerciseName = exerciseNames[i];
      Exercise exercise = Exercise(name: exerciseName, sets: sets);
      exercises.add(exercise);
    }

    WorkoutTemplate workoutTemplate = WorkoutTemplate(
      workoutName: workoutName,
      workoutExercises: exercises,
      sets: sets,
      date: date,
    );

    workoutTemplates.add(workoutTemplate);
  }
  print('HALOOOO: ${workoutTemplates[0].workoutExercises}');
  return workoutTemplates;
}
