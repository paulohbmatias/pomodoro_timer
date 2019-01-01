import 'dart:async';

class Transformers {
  final timerTransform =
      StreamTransformer<int, String>.fromHandlers(handleData: (timer, sink) {
        print("ta aqui");
        print(timer);
        sink.add("${(timer ~/ 60).toString().padLeft(2, '0')} "
            ": ${(timer % 60).toString().padLeft(2, '0')}");
      });
}
