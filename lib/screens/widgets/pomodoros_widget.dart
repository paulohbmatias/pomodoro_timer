import 'package:flutter/material.dart';

class ListPomodoros extends StatelessWidget {

  final int pomodoros;

  const ListPomodoros({Key key, this.pomodoros}) : super(key: key);

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
          height: 24,
          width: 24,
        ));
      else
        list.add(Image.asset(
          'assets/pomodoro.png',
          color: Colors.white,
          height: 24,
          width: 24,
        ));
      list.add(SizedBox(width: 8,));
    }
    list.removeLast();
    return list;
  }
}
