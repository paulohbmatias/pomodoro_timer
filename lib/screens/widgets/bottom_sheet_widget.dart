import 'package:flutter/material.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';
import 'package:pomodoro_timer/i18n/localization.dart';

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
                title: Text(Localization.of(context).pomodoro),
                icon: Icon(Icons.timer),
              ),
              BottomNavigationBarItem(
                title: Text(Localization.of(context).shortBreak),
                icon: Icon(Icons.free_breakfast),
              ),
              BottomNavigationBarItem(
                title: Text(Localization.of(context).longBreak),
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
