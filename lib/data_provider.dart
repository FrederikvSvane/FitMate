import 'package:flutter_fitness_app/pages/profile.dart';
import 'package:health/health.dart';

class DataProvider {
  static HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  static Future<StepAndCalorieData> fetchStepDataFromDate(DateTime date) async {
    DateTime before = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime after = DateTime(date.year, date.month, date.day, 23, 59, 59);

    int? stepsData;

    if (ProfileState.requested) { // access the requested variable from ProfileState class

      stepsData = await health.getTotalStepsInInterval(before, after);


      int steps = stepsData ?? 0;
      double basalCalories = ProfileState.basalCalorieBurner(); // access the basalCalorieBurner function from ProfileState class
      double stepCalories = ProfileState.stepCalorieBurner(steps);

      return StepAndCalorieData(
          steps: steps,
          basalCalories: basalCalories,
          stepCalories: stepCalories,
          totalCalories: basalCalories + stepCalories);
    } else {
      double basalCalories = ProfileState.basalCalorieBurner(); // access the basalCalorieBurner function from ProfileState class
      return StepAndCalorieData(
          steps: 0, basalCalories: basalCalories, stepCalories: 0, totalCalories: basalCalories + 0);
    }
  }
}
