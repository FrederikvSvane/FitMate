import 'dart:async';

class TimerService {
  late StreamController<int> streamController;
  Timer? timer;
  int counter = 0;

  TimerService() {
    streamController = StreamController<int>.broadcast();
  }

  Stream<int> get timerStream => streamController.stream;

  void startTimer() {
    void tick(Timer timer) {
      counter++;
      if (!streamController.isClosed) {
        streamController.add(counter);
      }
    }

    timer = Timer.periodic(Duration(seconds: 1), tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  void resetCounter() {
    counter = 0;
    if (!streamController.isClosed) {
      streamController.add(counter);
    }
  }

  void dispose() {
    streamController.close();
  }
}




