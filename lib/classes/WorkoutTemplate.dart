import '../DB/DBHelper.dart';
import 'Exercise.dart';

class WorkoutTemplate {
  String workoutName = '';
  List<Exercise> workoutExercises = [];
  String date = '';

  WorkoutTemplate(
      {required this.workoutName,
      required this.workoutExercises,
      required this.date});
}

Future<List<WorkoutTemplate>> convertToWorkoutTemplates() async {
  List<Map<String, dynamic>> workoutMaps = await DBHelper.getWorkouts();
  List<WorkoutTemplate> workoutTemplates = [];
  for (var workoutMap in workoutMaps) {
    String workoutName = workoutMap['workoutName'];
    String exercisesString = workoutMap['exercises'];
    String typesString = workoutMap['type'];
    String setsString = workoutMap['sets'];
    String date = workoutMap['date'];

    List<String> exerciseNames = exercisesString.split(',');
    exerciseNames.removeLast();
    List<int> sets = setsString
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(int.parse)
        .toList();
    List<int> types = typesString
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(int.parse)
        .toList();

    List<Exercise> exercises = [];
    for (int i = 0; i < exerciseNames.length; i++) {
      List<int> currentSets = [];
      for (int j = 0; j < sets[i]; j++) {
        currentSets.add(j + 1);
      }
      String exerciseName = exerciseNames[i];
      Exercise exercise = Exercise(name: '');
      if (types[i] == 1) {
        exercise = Exercise(
            name: exerciseName, sets: currentSets, weight: [], reps: []);
      } else if (types[i] == 2) {
        exercise = Exercise(
            name: exerciseName, sets: currentSets, distance: [], time: []);
      } else if (types[i] == 3) {
        exercise = Exercise(name: exerciseName, sets: currentSets, time: []);
      } else {
        exercise = Exercise(name: exerciseName, sets: currentSets, reps: []);
      }
      exercises.add(exercise);
    }

    WorkoutTemplate workoutTemplate = WorkoutTemplate(
      workoutName: workoutName,
      workoutExercises: exercises,
      date: date,
    );
    workoutTemplates.add(workoutTemplate);
  }
  List<Exercise> chestExercises = [
    Exercise(name: "Bench Press", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Chest Flyes", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Dips", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Triceps Extensions", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Shoulder Press", sets: [1, 2, 3], reps: [], weight: [])
  ];

  WorkoutTemplate chestTemplate = WorkoutTemplate(
      workoutName: "Push Workout", workoutExercises: chestExercises, date: "");

  List<Exercise> pullExercises = [
    Exercise(name: "Face Pull", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Lat Pulldowns", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Deadlift", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Bicep Curls", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Barbell Row", sets: [1, 2, 3], reps: [], weight: [])
  ];

  WorkoutTemplate pullTemplate = WorkoutTemplate(
      workoutName: "Pull Workout", workoutExercises: pullExercises, date: "");

  List<Exercise> legExercises = [
    Exercise(name: "Squat", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Leg Press", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Leg Curls", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Leg Extensions", sets: [1, 2, 3], reps: [], weight: []),
    Exercise(name: "Calf Raises", sets: [1, 2, 3], reps: [], weight: [])
  ];

  WorkoutTemplate legTemplate = WorkoutTemplate(
      workoutName: "Leg Workout", workoutExercises: legExercises, date: "");

  workoutTemplates.add(chestTemplate);
  workoutTemplates.add(pullTemplate);
  workoutTemplates.add(legTemplate);

  return workoutTemplates;
}
