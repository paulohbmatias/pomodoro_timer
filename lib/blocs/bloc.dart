import 'package:pomodoro_timer/blocs/transformers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quiver/async.dart';

class Bloc extends Object with Transformers{

  // 25 * 60
  final int seconds = 1500;
  final double oneSecondInPercent = 100/1500;

  final _timer = BehaviorSubject<int>();
  final _percent = BehaviorSubject<double>();

  Stream<String> get timer => _timer.stream.transform(timerTransform);
  Stream<double> get percent => _percent.stream;

  Function(int) get changeTimer => _timer.sink.add;
  Function(double) get changePercent => _percent.sink.add;

  initCountDown(){
    new CountdownTimer(new Duration(seconds: seconds), new Duration(seconds: 1)).listen((data) {
      changeTimer(data.remaining.inSeconds);
      changePercent(oneSecondInPercent * data.remaining.inSeconds);
    });
  }

  dispose(){
    _timer.close();
    _percent.close();
  }

}

final bloc = Bloc();