import 'package:flutter/services.dart';

class LocalNotification{

  static const platform = const MethodChannel('com.pomodoro.pomodorotimer/notification');

  void cancelNotification() async{
    try{
      await platform.invokeMethod('cancelNotification');
    }catch(e){
      print(e);
    }
  }


  void createNotification(String title, String content) async {
    try{
      Map<String, String> map = {
        'title': title,
        'content': content
      };
      await platform.invokeMethod('createNotification', map);
    }catch(e){
      print(e);
    }
  }

  void updateNotification(String content) async {
    try{
      Map<String, String> map = {
        'content': content
      };
      await platform.invokeMethod('updateNotification', map);
    }catch(e){
      print(e);
    }
  }

  void pauseNotification(String title, String content) async {
    try{
      Map<String, String> map = {
        'title': title,
        'content': content
      };
      await platform.invokeMethod('timeOverNotification', map);
    }catch(e){
      print(e);
    }
  }

  void workNotification(String title, String content) async {
    try{
      Map<String, String> map = {
        'title': title,
        'content': content
      };
      await platform.invokeMethod('timeOverNotification', map);
    }catch(e){
      print(e);
    }
  }
}