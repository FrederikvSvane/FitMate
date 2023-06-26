import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:intl/intl.dart';
import '../pages/profile.dart';
import '../data_provider.dart';


class ListBuilder1 extends StatelessWidget {
  const ListBuilder1({super.key});

  String getTheDaysProtiensStats(String totalProtein) {
    if (double.tryParse(totalProtein)! > protiensGoal) {
      return 'Day ended with a surplus of ${(double.tryParse(totalProtein)! - protiensGoal).abs()} grams';
    } else {
      return 'Day ended with a protein deficit of ${(protiensGoal - double.tryParse(totalProtein)!).abs()} grams';
    }
  }

  String getTheDaysCaloriesStats(String totalCalories) {
    if (double.tryParse(totalCalories)! > caloriesGoal) {
      return 'Day ended with a surplus of ${(double.tryParse(totalCalories)! - caloriesGoal).abs()} calories';
    } else {
      return 'Day ended with a calorie deficit of ${(caloriesGoal - double.tryParse(totalCalories)!).abs()} calories';
    }
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemBuilder: (BuildContext context, index) {
          DateTime currentDate = DateTime.now().subtract(Duration(days: index));
          DateTime before = DateTime(currentDate.year, currentDate.month, currentDate.day, 0, 0, 0);
          DateTime after = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
          Future<List<Map<String, dynamic>>> dbData = DBHelper.getProteinsForDateRange(before, after);
          Future<List<Map<String, dynamic>>> dbData2 = DBHelper.getCaloriesForDateRange(before, after);
          Future<StepAndCalorieData> stepAndCalorieData = DataProvider.fetchStepDataFromDate(currentDate);

          return FutureBuilder<List<dynamic>>(
            future: Future.wait([dbData, dbData2, stepAndCalorieData]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> proteinData = snapshot.data?[0];
                List<Map<String, dynamic>> calorieData = snapshot.data?[1];
                StepAndCalorieData data = snapshot.data?[2];

                String totalProtein = proteinData[0]['totalProteins'].toString();
                String totalCalories = calorieData[0]['totalCalories'].toString();

                int stepsTaken = data.steps;
                double activeCalories = data.stepCalories;
                double basalCalories = data.basalCalories;
                double totalCaloriesUsed = data.totalCalories;

                return Container(
                  height: 285,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          DateFormat('EEEE, MMMM d yyyy').format(currentDate),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Steps taken: $stepsTaken',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              height: 150,
                              color: Colors.grey[50],
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: 10,
                                          child: Text("Calories burned ",
                                              style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.grey[600],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 10,
                                          child: Text("Active calories: ",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 10,
                                          child: Text("Basal calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 10,
                                          child: Text("Total calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 140,
                                          child: Text(activeCalories.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 140,
                                          child: Text(basalCalories.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 140,
                                          child: Text(totalCaloriesUsed.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Container(
                              height: 150,
                              color: Colors.grey[50],
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: 10,
                                          child: Text("Calories consumed ",
                                              style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.grey[600],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 10,
                                          child: Text("Protein goal:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 10,
                                          child: Text("Total Protein:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 10,
                                          child: Text("Total calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 140,
                                          child: Text(protiensGoal.toString(),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 140,
                                          child: Text(totalProtein,
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 140,
                                          child: Text(totalCalories,
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getTheDaysProtiensStats(totalProtein),
                            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getTheDaysCaloriesStats(totalCalories),
                            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
  }
}

class ListBuilder2 extends StatelessWidget {
  const ListBuilder2({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 30,
      itemBuilder: (BuildContext context, index) {
        DateTime currentDate = DateTime.now().subtract(Duration(days: index));

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: DBHelper.getExercisesForDate(currentDate),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final exercises = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                itemBuilder: (context, exerciseIndex) {
                  final exercise = exercises[exerciseIndex];
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('EEEE, MMMM d, yyyy').format(currentDate),
                              style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          SizedBox(height: 10),
                          Text('${exercise['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 10),
                          if (exercise['sets'] != '') ...[
                            Text('Sets: ${exercise['sets']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['reps'] != '') ...[
                            Text('Reps: ${exercise['reps']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['weight'] != '') ...[
                            Text('Weight: ${exercise['weight']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['time'] != '') ...[
                            Text('Time: ${exercise['time']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['distance'] != '') ...[
                            Text('Distance: ${exercise['distance']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}