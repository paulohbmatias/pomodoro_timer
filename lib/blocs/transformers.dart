import 'dart:async';

import 'package:pomodoro_timer/enums/status_pomodoro.dart';
import 'package:pomodoro_timer/helpers/local_notification.dart';

class Transformers{
  final timerTransform =
      StreamTransformer<int, String>.fromHandlers(handleData: (timer, sink) {
        sink.add("${(timer ~/ 60).toString().padLeft(2, '0')} "
            ": ${(timer % 60).toString().padLeft(2, '0')}");

      });
  final pageTransform =
      StreamTransformer<int, StatusPomodoro>.fromHandlers(handleData: (page, sink) {
        switch(page){
          case 0: sink.add(StatusPomodoro.pomodoro); break;
          case 0: sink.add(StatusPomodoro.shortBreak); break;
          case 0: sink.add(StatusPomodoro.longBreak); break;
        }
      });
}
