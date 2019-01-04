import 'package:pomodoro_timer/blocs/transformers.dart';
import 'dart:async';

class Bloc extends Object with Transformers {

  Duration duration = Duration(minutes: 25);
  double _percent = 100;
  final double oneSecondInPercent = 100 / 1500;
  Stopwatch stopwatch = Stopwatch();

  final _timer = StreamController<int>();
  final _isRunning = StreamController<bool>();
  final _isStarted = StreamController<bool>();

  Stream<String> get timer => _timer.stream.transform(timerTransform);

  Stream<bool> get isRunning => _isRunning.stream;

  Stream<bool> get isStarted => _isStarted.stream;

  double get percent => _percent;

  Function(int) get changeTimer => _timer.sink.add;

  Function(bool) get changeIsRunning => _isRunning.sink.add;

  Function(bool) get changeIsStarted => _isStarted.sink.add;

  void initCountDown() {
    Timer.periodic(Duration(seconds: 1), (timer){
      int time = duration.inSeconds - stopwatch.elapsed.inSeconds;
      changeTimer(time);
      _percent = oneSecondInPercent * time;

    });
    stopwatch.start();
    changeIsRunning(true);
    changeIsStarted(true);
  }

  void pauseCountDown() {
    changeIsRunning(false);
    stopwatch.stop();
  }

  void stopCountDown() {
    changeIsRunning(false);
    changeIsStarted(false);
    stopwatch.stop();
    stopwatch.reset();
  }


  dispose() {
    _timer.close();
    _isRunning.close();
    _isStarted.close();
  }
}

final bloc = Bloc();
