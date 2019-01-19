import 'package:flutter/material.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';

class BottomSheetPomodoro extends StatelessWidget {

  final Bloc bloc;

  const BottomSheetPomodoro(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: bloc.page,
        initialData: 0,
        builder: (context, snapshot){
          return BottomNavigationBar(
            fixedColor: Colors.red[500],
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text("Work"),
                icon: Icon(Icons.timer),
              ),
              BottomNavigationBarItem(
                title: Text("Short Break"),
                icon: Icon(Icons.free_breakfast),
              ),
              BottomNavigationBarItem(
                title: Text("Long Break"),
                icon: Icon(Icons.tv),
              ),
            ],
            currentIndex: snapshot.data,
            onTap: bloc.changePage,
          );
        }
    );
  }
}
