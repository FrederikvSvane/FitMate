import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import '../DB/DBHelper.dart';

class Measure extends StatefulWidget {
  const Measure({Key? key}) : super(key: key);

  @override
  State<Measure> createState() => MeasureState();
}

List<TimeSeriesCalories> extrapolateFutureData(List<TimeSeriesCalories> data,
    LinearRegression regression, int futureDays) {
  var futureData = List<TimeSeriesCalories>.from(data);

  for (var i = 1; i <= futureDays; i++) {
    var futureDate = data[data.length - 1].time.add(Duration(days: i));
    var futureValue = regression.slope * futureDate.millisecondsSinceEpoch +
        regression.intercept;
    futureData.add(TimeSeriesCalories(futureDate, futureValue));
  }

  return futureData;
}

LinearRegression calculateRegression(List<TimeSeriesCalories> data) {
  int n = data.length;
  double sumX = 0;
  double sumY = 0;
  double sumXY = 0;
  double sumXX = 0;

  for (var i = 0; i < n; i++) {
    sumX += data[i].time.millisecondsSinceEpoch;
    sumY += data[i].calories;
    sumXX += data[i].time.millisecondsSinceEpoch *
        data[i].time.millisecondsSinceEpoch;
    sumXY += data[i].time.millisecondsSinceEpoch * data[i].calories;
  }

  double slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
  double intercept = (sumY - slope * sumX) / n;

  return LinearRegression(slope, intercept);
}

class LinearRegression {
  final double slope;
  final double intercept;

  LinearRegression(this.slope, this.intercept);
}

charts.Series<TimeSeriesCalories, DateTime> createRegressionSeries(
    List<TimeSeriesCalories> data,
    LinearRegression regression,
    int futureDays) {
  var futureData = extrapolateFutureData(data, regression, futureDays);

  return charts.Series<TimeSeriesCalories, DateTime>(
    id: 'Calories Regression',
    colorFn: (_, __) =>
        charts.ColorUtil.fromDartColor(const Color.fromARGB(50, 255, 0, 0)),
    // Semi-transparent color
    domainFn: (TimeSeriesCalories calories, _) => calories.time,
    measureFn: (TimeSeriesCalories calories, _) =>
        regression.slope * calories.time.millisecondsSinceEpoch +
        regression.intercept,
    data: futureData,
    displayName: 'Prediction for the next 7 days',
  );
}

class MeasureState extends State<Measure> {
  final bool animate = false;
  late DateTimeRange selectedDateRange;

  MeasureState() {
    final now = DateTime.now();
    selectedDateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  Future<List<charts.Series<TimeSeriesCalories, DateTime>>>
      _fetchCaloriesData() async {
    final dbData = await DBHelper.getCaloriesForDateRange(
        selectedDateRange.start, selectedDateRange.end);
    final data = dbData
        .map((d) =>
            TimeSeriesCalories(DateTime.parse(d['date']), d['totalCalories']))
        .toList();

    // Calculate regression
    var regression = calculateRegression(data);

    // Create regression series
    var regressionSeries = createRegressionSeries(data, regression, 7);

    return [
      charts.Series<TimeSeriesCalories, DateTime>(
        id: 'Calories',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesCalories calories, _) => calories.time,
        measureFn: (TimeSeriesCalories calories, _) => calories.calories,
        data: data,
        labelAccessorFn: (TimeSeriesCalories calories, _) =>
            '${calories.calories.toInt()}',
      ),
      regressionSeries,
    ];
  }

  //Fetch the data for the proteins chart
  Future<List<charts.Series<TimeSeriesProteins, DateTime>>>
      _fetchProteinsData() async {
    final dbData = await DBHelper.getProteinsForDateRange(
        selectedDateRange.start, selectedDateRange.end);
    final data = dbData
        .map((d) =>
            TimeSeriesProteins(DateTime.parse(d['date']), d['totalProteins']))
        .toList();

    return [
      charts.Series<TimeSeriesProteins, DateTime>(
        id: 'Proteins',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesProteins proteins, _) => proteins.time,
        measureFn: (TimeSeriesProteins proteins, _) => proteins.proteins,
        data: data,
        labelAccessorFn: (TimeSeriesProteins proteins, _) =>
            '${proteins.proteins.toInt()}',
      ),
    ];
  }

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: Colors.red[800],
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  Widget _buildTimeSeriesChart<T>(
    List<charts.Series<T, DateTime>> seriesList,
  ) {
    return SizedBox(
      height: 200,
      child: charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
        behaviors: [
          charts.LinePointHighlighter(
            symbolRenderer: charts.CircleSymbolRenderer(),
            defaultRadiusPx: 4,
          ),
          charts.SeriesLegend(), // Add a series legend
        ],
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade300,
            ),
            labelStyle: const charts.TextStyleSpec(
              fontSize: 14,
            ),
            axisLineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade500,
            ),
          ),
          tickProviderSpec:
              const charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Measure'),
            Text(
              '${DateFormat('MMM dd, yyyy').format(selectedDateRange.start)} - ${DateFormat('MMM dd, yyyy').format(selectedDateRange.end)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<charts.Series<TimeSeriesCalories, DateTime>>>(
              future: _fetchCaloriesData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildTimeSeriesChart(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Proteins',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<charts.Series<TimeSeriesProteins, DateTime>>>(
              future: _fetchProteinsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildTimeSeriesChart(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesCalories {
  final DateTime time;
  final double calories;

  TimeSeriesCalories(this.time, this.calories);
}

class TimeSeriesProteins {
  final DateTime time;
  final double proteins;

  TimeSeriesProteins(this.time, this.proteins);
}
