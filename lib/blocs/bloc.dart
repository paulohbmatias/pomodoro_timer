import 'package:pomodoro_timer/blocs/transformers.dart';
import 'dart:async';

import 'package:pomodoro_timer/enums/status_pomodoro.dart';

class Bloc extends Object with Transformers {

  Duration duration;
  double _percent = 100;
  double oneSecondInPercent;
  int _secondesInShortBreak = 5;
  int _secondesInLongBreak = 7;
  int _secondesInPomodoro = 10;
  int _countPomodoros = 0;
  int _pomodoroPage = 0;
  int _shortBreakPage = 1;
  int _longBreakPage = 2;

  StatusPomodoro _statusPomodoro = StatusPomodoro.pomodoro;

  Stopwatch stopwatch = Stopwatch();

  final _timer = StreamController<int>();
  final _isRunning = StreamController<bool>();
  final _isStarted = StreamController<bool>();
  final _pomodoros = StreamController<int>();
  final _page = StreamController<int>();

  Stream<String> get timer => _timer.stream.transform(timerTransform);
  Stream<bool> get isRunning => _isRunning.stream;
  Stream<bool> get isStarted => _isStarted.stream;
  Stream<int> get page => _page.stream;

  double get percent => _percent;
  int get pomodoros => _countPomodoros;

  Function(int) get changeTimer => _timer.sink.add;
  Function(bool) get changeIsRunning => _isRunning.sink.add;
  Function(bool) get changeIsStarted => _isStarted.sink.add;
  void changePage(int page){
    switch(page){
      case 0:
        changeStatusTime(StatusPomodoro.pomodoro);
        break;
      case 1:
        changeStatusTime(StatusPomodoro.shortBreak);
        break;
      case 2:
        changeStatusTime(StatusPomodoro.longBreak);
        break;

    }
  }


  void initCountDown() {
    if(oneSecondInPercent == null)
      oneSecondInPercent = 100/_secondesInPomodoro;
    if(duration == null)
      duration = Duration(seconds: _secondesInPomodoro);
    Timer.periodic(Duration(milliseconds: 500), (timer){
      int time = duration.inSeconds - stopwatch.elapsed.inSeconds;
      changeTimer(time);
      _percent = oneSecondInPercent * time;
      if(time == 0 && _statusPomodoro == StatusPomodoro.pomodoro && _countPomodoros == 3 ){
        _countPomodoros = 0;
        changeStatusTime(StatusPomodoro.longBreak);
      }else if(time == 0 && _statusPomodoro == StatusPomodoro.pomodoro && _countPomodoros < 3){
        _countPomodoros++;
        changeStatusTime(StatusPomodoro.shortBreak);
      }else if(time == 0){
        changeStatusTime(StatusPomodoro.pomodoro);
      }
    });
  }


  void changeStatusTime(StatusPomodoro status){
    switch(status){
      case StatusPomodoro.pomodoro:
        _statusPomodoro = StatusPomodoro.pomodoro;
        oneSecondInPercent = 100/_secondesInPomodoro;
        duration = Duration(seconds: _secondesInPomodoro);
        _page.sink.add(_pomodoroPage);
        break;
      case StatusPomodoro.shortBreak:
        _statusPomodoro = StatusPomodoro.shortBreak;
        duration = Duration(seconds: _secondesInShortBreak);
        oneSecondInPercent = 100/_secondesInShortBreak;
        _page.sink.add(_shortBreakPage);
        break;
      case StatusPomodoro.longBreak:
        _statusPomodoro = StatusPomodoro.longBreak;
        duration = Duration(seconds: _secondesInLongBreak);
        oneSecondInPercent = 100/_secondesInLongBreak;
        _page.sink.add(_longBreakPage);
        break;
    }
    stopCountDown();

  }
  void startCountDown(){
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
    _pomodoros.close();
    _page.close();
  }
}

final bloc = Bloc();
