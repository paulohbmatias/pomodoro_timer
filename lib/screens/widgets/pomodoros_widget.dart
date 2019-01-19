import 'package:flutter/material.dart';

class ListPomodoros extends StatelessWidget {

  final int pomodoros;
  final double width;

  const ListPomodoros(this.pomodoros, this.width);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getPomodoros(pomodoros),
    );
  }

  List<Widget> getPomodoros(int pomodoros){
    List<Widget> list = List();
    for(int i = 1; i <= 4; i++){
      if(i <= pomodoros)
        list.add(Image.asset(
          'assets/pomodoro_fill.png',
          height: width < 350 ? 24 : 42,
        ));
      else
        list.add(Image.asset(
          'assets/pomodoro.png',
          color: Colors.white,
          height: width < 350 ? 24 : 42,
        ));
      list.add(SizedBox(width: 8,));
    }
    list.removeLast();
    return list;
  }
}
