import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AddFood Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: AddFood()));

    // Verify that the add food page contains the correct elements
    expect(find.text('Add Food'), findsOneWidget);
    expect(find.text('Name:'), findsOneWidget);
    expect(find.text('Calories:'), findsOneWidget);
    expect(find.text('Proteins:'), findsOneWidget);
    expect(find.text('How much did you eat? (in grams)'), findsOneWidget);
    expect(find.byIcon(Icons.download_sharp), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Test the text fields
    await tester.enterText(find.widgetWithText(TextField, 'Enter name'), 'Apple');
    expect(find.text('Apple'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Enter calories'), '95');
    expect(find.text('95'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Enter proteins'), '0.3');
    expect(find.text('0.3'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'how many grams'), '150');
    expect(find.text('150'), findsOneWidget);

    // Tap the 'Add' button and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });
}
