import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';

class SearchExercises extends SearchDelegate<Exercise> {
  final List<Exercise> exerciseList; // Replace with your exercise list

  SearchExercises(this.exerciseList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Exercise(name: "null"));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform the search logic here
    List<Exercise> searchResults = exerciseList
        .where((exercise) =>
            exercise.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Display the search results
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].name),
          onTap: () {
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions based on user input (optional)
    return Container();
  }
}
