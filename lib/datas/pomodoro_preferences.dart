import 'package:shared_preferences/shared_preferences.dart';

class PomodoroPreferences{

  static const pomodoro = "pomodoro";
  static const shortBreak = "shortBreak";
  static const longBreak = "longBreak";
  static const lastDataTimeBeforeInactive = "lastDataTimeBeforeInactive";
  static const lastTimeBeforeInactive = "lastTimeBeforeInactive";

  final SharedPreferences prefs;

  PomodoroPreferences(this.prefs);


  setTimePomodoro(int time) async{
    prefs.setInt(pomodoro, time);
  }

  setTimeShortBreak(int time) async{
    prefs.setInt(shortBreak, time);
  }

  setTimeLongBreak(int time) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(longBreak, time);
  }

  setLastDataTimeBeforeInactive(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(lastDataTimeBeforeInactive, time);
  }

  setLastTimeBeforeInactive(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(lastTimeBeforeInactive, time);
  }

  int getTimePomodoro(){
    return prefs.getInt(pomodoro);
  }

  int getTimeShortBreak(){
    return prefs.getInt(shortBreak);
  }

  int getTimeLongBreak(){
    return prefs.getInt(longBreak);
  }

  int getLastDataTimeBeforeInactive(){
    return prefs.getInt(lastDataTimeBeforeInactive);
  }

  int getLastTimeBeforeInactive(){
    return prefs.getInt(lastTimeBeforeInactive) ?? -1;
  }


}