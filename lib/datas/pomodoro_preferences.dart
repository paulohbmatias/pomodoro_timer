import 'package:shared_preferences/shared_preferences.dart';

class PomodoroPreferences{

  static const pomodoro = "pomodoro";
  static const shortBreak = "shortBreak";
  static const longBreak = "longBreak";

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

  int getTimePomodoro(){
    return prefs.getInt(pomodoro);
  }

  int getTimeShortBreak(){
    return prefs.getInt(shortBreak);
  }

  int getTimeLongBreak(){
    return prefs.getInt(longBreak);
  }
}