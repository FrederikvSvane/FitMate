import 'dart:async';

class TimerService {
  late Stream<int> timerStream;
  StreamSubscription<int>? timerSubscription;

  TimerService() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      // Perform any additional action here as the time ticks, if necessary.
    });
  }

  Stream<int> stopWatchStream() {
    late StreamController<int> streamController;
    Timer? timer;
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      streamController = StreamController<int>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer,
      );
      timer = Timer.periodic(Duration(seconds: 1), tick);
    }

    startTimer();
    return streamController.stream;
  }

  void dispose() {
    timerSubscription?.cancel();
  }
}
