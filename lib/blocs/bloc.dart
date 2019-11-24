import 'package:pomodoro_timer/blocs/transformers.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/datas/pomodoro_preferences.dart';
import 'package:pomodoro_timer/enums/status_pomodoro.dart';
import 'package:pomodoro_timer/helpers/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro_timer/i18n/localization.dart';

class Bloc extends Object with Transformers, LocalNotification{

  BuildContext context;
  Duration duration;
  double _percent = 100;
  double oneSecondInPercent;
  int _secondesInShortBreak;
  int _secondesInLongBreak;
  int _secondesInPomodoro;
  int _countPomodoros = 0;
  int _pomodoroPage = 0;
  int _shortBreakPage = 1;
  int _longBreakPage = 2;
  int _lastTimeBeforeInactive;
  int _lastDataTimeBeforeInactive;
  int _timeRemaining;
  List<int> timePomodoro = [20, 25, 30, 35, 40, 45, 50, 55, 60];
  List<int> timeShortBreak = [3, 5, 7];
  List<int> timeLongBreak = [15, 20, 25, 30];
  PomodoroPreferences prefs;
  bool notificationIsActive = false;

  StatusPomodoro _statusPomodoro = StatusPomodoro.pomodoro;
  Stopwatch stopwatch = Stopwatch();


  final _timer = StreamController<int>.broadcast();
  final _isRunning = StreamController<bool>();
  final _isStarted = StreamController<bool>.broadcast();
  final _isBottomSheetOpen = StreamController<bool>.broadcast();
  final _pomodoros = StreamController<int>();
  final _page = StreamController<int>();
  final _secondsPomodoroStream = StreamController<int>.broadcast();
  final _secondsShortBreakStream = StreamController<int>.broadcast();
  final _secondsLongBreakStream = StreamController<int>.broadcast();

  Stream<String> get timer => _timer.stream.transform(timerTransform);
  Stream<bool> get isRunning => _isRunning.stream;
  Stream<bool> get isStarted => _isStarted.stream;
  Stream<bool> get isBottomSheetOpen => _isBottomSheetOpen.stream;
  Stream<int> get page => _page.stream;
  Stream<int> get secondsPomodoro => _secondsPomodoroStream.stream;
  Stream<int> get secondsShortBreak => _secondsShortBreakStream.stream;
  Stream<int> get secondsLongBreak => _secondsLongBreakStream.stream;

  double get percent => _percent;
  int get pomodoros => _countPomodoros;
  int get getTimePomodoro => _secondesInPomodoro~/60;
  int get getTimeShortBreak => _secondesInShortBreak~/60;
  int get getTimeLongBreak => _secondesInLongBreak~/60;

  Function(int) get changeTimer => _timer.sink.add;
  Function(bool) get changeIsRunning => _isRunning.sink.add;
  Function(bool) get changeIsStarted => _isStarted.sink.add;
  Function(bool) get changeIsBottomSheetOpen => _isBottomSheetOpen.sink.add;
  Function(int) get changeSecondsPomodoro => _secondsPomodoroStream.sink.add;
  Function(int) get changeSecondsShortBreak => _secondsShortBreakStream.sink.add;
  Function(int) get changeSecondsLongBreak => _secondsLongBreakStream.sink.add;

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


  void initCountDown() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    prefs = PomodoroPreferences(sharedPreferences);
    _secondesInPomodoro = prefs.getTimePomodoro() ?? 1500;
    _secondesInShortBreak = prefs.getTimeShortBreak() ?? 300;
    _secondesInLongBreak = prefs.getTimeLongBreak() ?? 900;
    secondsPomodoro.listen(
        (seconds){
          prefs.setTimePomodoro(seconds * 60);
          _secondesInPomodoro = 60 * seconds;
          if(_statusPomodoro == StatusPomodoro.pomodoro)
            changeStatusTime(_statusPomodoro);
        }
    );
    secondsShortBreak.listen(
            (seconds){
          prefs.setTimeShortBreak(seconds * 60);
          _secondesInShortBreak = seconds * 60;
          if(_statusPomodoro == StatusPomodoro.shortBreak)
            changeStatusTime(_statusPomodoro);
        }
    );
    secondsLongBreak.listen(
            (seconds){
          prefs.setTimeLongBreak(seconds * 60);
          _secondesInLongBreak = seconds * 60;
          if(_statusPomodoro == StatusPomodoro.longBreak)
            changeStatusTime(_statusPomodoro);
        }
    );

    timer.listen(
        (timer){
            if(notificationIsActive)
              updateNotification(timer);
        }
    );

    isStarted.listen(
        (isStarted){
          if(isStarted){
            switch(_statusPomodoro){
              case StatusPomodoro.pomodoro:
                createNotification(Localization.of(context).timeIsRunning, "${(_secondesInPomodoro ~/ 60).toString().padLeft(2, '0')} "
                    ": ${(_secondesInPomodoro % 60).toString().padLeft(2, '0')}");
                break;
              case StatusPomodoro.shortBreak:
                createNotification(Localization.of(context).timeIsRunning, "${(_secondesInShortBreak ~/ 60).toString().padLeft(2, '0')} "
                    ": ${(_secondesInShortBreak % 60).toString().padLeft(2, '0')}");
                break;
              case StatusPomodoro.longBreak:
                createNotification(Localization.of(context).timeIsRunning, "${(_secondesInLongBreak ~/ 60).toString().padLeft(2, '0')} "
                    ": ${(_secondesInLongBreak % 60).toString().padLeft(2, '0')}");
                break;
            }
          }else{
            cancelNotification();
            notificationIsActive = false;
          }
        }
    );

    if(oneSecondInPercent == null)
      oneSecondInPercent = 100/_secondesInPomodoro;
    if(duration == null)
      duration = Duration(seconds: _secondesInPomodoro);

    Timer.periodic(Duration(milliseconds: 1000), (timer){
      _timeRemaining = duration.inSeconds - stopwatch.elapsed.inSeconds;
      changeTimer(_timeRemaining);
      _percent = oneSecondInPercent * _timeRemaining;
      if(_timeRemaining == 0 && _statusPomodoro == StatusPomodoro.pomodoro && _countPomodoros == 3 ){
        _countPomodoros = 0;
        pauseNotification(Localization.of(context).pomodoroIsOver, Localization.of(context).itsTimeFor + Localization.of(context).longBreak.toLowerCase());
        changeStatusTime(StatusPomodoro.longBreak);
      }else if(_timeRemaining == 0 && _statusPomodoro == StatusPomodoro.pomodoro && _countPomodoros < 3){
        _countPomodoros++;
        pauseNotification(Localization.of(context).pomodoroIsOver, Localization.of(context).itsTimeFor + Localization.of(context).shortBreak.toLowerCase());
        changeStatusTime(StatusPomodoro.shortBreak);
      }else if(_timeRemaining == 0){
        workNotification(Localization.of(context).breakIsOver, Localization.of(context).itsTimeToWork);
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

  Future<bool> closeScreen({BuildContext context}) async{
    changeIsBottomSheetOpen(false);
    if(context != null)
      Navigator.of(context).pop();
    return true;
  }

  void startCountDown(){
    stopwatch.start();
    notificationIsActive = true;
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
    switch(_statusPomodoro){
      case StatusPomodoro.pomodoro:
        duration = Duration(seconds: _secondesInPomodoro);
        break;
      case StatusPomodoro.shortBreak:
        duration = Duration(seconds: _secondesInShortBreak);
        break;
      case StatusPomodoro.longBreak:
        duration = Duration(seconds: _secondesInLongBreak);
        break;

    }
    stopwatch.reset();
  }


  dispose() {
    _timer.close();
    _isRunning.close();
    _isStarted.close();
    _isBottomSheetOpen.close();
    _pomodoros.close();
    _page.close();
    _secondsPomodoroStream.close();
    _secondsShortBreakStream.close();
    _secondsLongBreakStream.close();
    cancelAllNotification();
  }
}

final bloc = Bloc();
