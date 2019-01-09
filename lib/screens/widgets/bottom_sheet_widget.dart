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
            fixedColor: Color.fromARGB(255, 229, 22, 22),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text("Pomodoro"),
                icon: Icon(Icons.timer),
              ),
              BottomNavigationBarItem(
                title: Text("Short Break"),
                icon: Icon(Icons.timer),
              ),
              BottomNavigationBarItem(
                title: Text("Long Break"),
                icon: Icon(Icons.timer),
              ),
            ],
            currentIndex: snapshot.data,
            onTap: bloc.changePage,
          );
        }
    );
  }
}
