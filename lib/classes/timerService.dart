import 'dart:async';

class TimerService {
  late Stream<int> timerStream;

  TimerService() {
    timerStream = stopWatchStream();
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController = StreamController<int>();
    Timer? timer;
    int counter = 0;

    void tick(Timer timer) {
      counter++;
      if (!streamController.isClosed) {
        streamController.add(counter);
      }
    }

    void startTimer() {
      timer = Timer.periodic(Duration(seconds: 1), tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
      }
    }

    startTimer();

    streamController.onCancel = stopTimer;

    return streamController.stream;
  }

  void dispose() {
    timerStream.drain();
  }
}
