import 'package:pomodoro_timer/blocs/transformers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quiver/async.dart';

class Bloc extends Object with Transformers{
  final _timer = BehaviorSubject<int>();

  Stream<String> get timer => _timer.stream.transform(timerTransform);

  Function(int) get changeTimer => _timer.sink.add;

  initCountDown(){
    new CountdownTimer(new Duration(minutes: 25), new Duration(seconds: 1)).listen((data) {
      changeTimer(data.remaining.inSeconds);
    });
  }

  dispose(){
    _timer.close();
  }

}

final bloc = Bloc();