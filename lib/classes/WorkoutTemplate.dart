import '../DB/DBHelper.dart';
import 'Exercise.dart';

class WorkoutTemplate{
  String workoutName = '';
  List<Exercise> workoutExercises = [];
  List<int> sets;
  String date = '';

  WorkoutTemplate({required this.workoutName, required this.workoutExercises, required this.sets, required this.date});
}

Future<List<WorkoutTemplate>> convertToWorkoutTemplates() async {
  List<Map<String, dynamic>> workoutMaps = await DBHelper.getWorkouts();
  List<WorkoutTemplate> workoutTemplates = [];
  print(workoutMaps[0]);
  for (var workoutMap in workoutMaps) {
    String workoutName = workoutMap['workoutName'];
    String exercisesString = workoutMap['exercises'];
    String typesString = workoutMap['types'];
    String setsString = workoutMap['sets'];
    String date = workoutMap['date'];

    List<String> exerciseNames = exercisesString.split(',');
    exerciseNames.removeLast();
    List<int> sets = setsString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> types = typesString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();

    List<Exercise> exercises = [];
    for (int i = 0; i < exerciseNames.length; i++) {
      String exerciseName = exerciseNames[i];
      Exercise exercise = Exercise(name: '');
      if (types[i] == 1){
        exercise = Exercise(name: exerciseName, sets: sets, weight: [], reps: []);
      } else if (types[i] == 2){
        exercise = Exercise(name: exerciseName, sets: sets, distance: [], time: []);
      } else if (types[i] == 3){
        exercise = Exercise(name: exerciseName, sets: sets, time: []);
      } else {
        exercise = Exercise(name: exerciseName, sets: sets, reps: []);
      }
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
