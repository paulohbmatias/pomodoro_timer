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


  void createNotification(String content) async {
    try{
      Map<String, String> map = {
        'title': 'Time is Running!',
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

  void pauseNotification(String content) async {
    try{
      Map<String, String> map = {
        'title': 'Your pomodoro is over!',
        'content': "It's time for a $content"
      };
      await platform.invokeMethod('timeOverNotification', map);
    }catch(e){
      print(e);
    }
  }

  void workNotification() async {
    try{
      Map<String, String> map = {
        'title': 'Your break is over',
        'content': "It's time to work!"
      };
      await platform.invokeMethod('timeOverNotification', map);
    }catch(e){
      print(e);
    }
  }
}