import 'package:flutter/material.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';

class SettingsScreen extends StatelessWidget {

  final Bloc bloc;

  const SettingsScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: (){
          print("fechou");
          bloc.changeIsBottomSheetOpen(false);
        },
        builder: (context){
          return Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<int>(
                  stream: bloc.secondsPomodoro,
                  initialData: bloc.getTimePomodoro,
                  builder: (context, snapshot){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Time of Pomodoro"),
                        DropdownButton<int>(
                          items: bloc.timePomodoro.map(
                                  (time) => DropdownMenuItem(
                                  value: time,
                                  child: Text(time.toString())
                              )
                          ).toList(),
                          value: snapshot.data,
                          onChanged: bloc.changeSecondsPomodoro,
                        )
                      ],
                    );
                  },
                ),
                StreamBuilder<int>(
                    stream: bloc.secondsShortBreak,
                    initialData: bloc.getTimeShortBreak,
                    builder: (context, snapshot){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("Time of Short Break"),
                          DropdownButton<int>(
                            items: bloc.timeShortBreak.map(
                                    (time) => DropdownMenuItem(
                                    value: time,
                                    child: Text(time.toString())
                                )
                            ).toList(),
                            value: snapshot.data,
                            onChanged: bloc.changeSecondsShortBreak,
                          )
                        ],
                      );
                    }
                ),
                StreamBuilder<int>(
                    stream: bloc.secondsLongBreak,
                    initialData: bloc.getTimeLongBreak,
                    builder: (context, snapshot){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("Time of Long Break"),
                          DropdownButton<int>(
                            items: bloc.timeLongBreak.map(
                                    (time) => DropdownMenuItem(
                                    value: time,
                                    child: Text(time.toString()))
                            ).toList(),
                            value: snapshot.data,
                            onChanged: bloc.changeSecondsLongBreak,
                          )
                        ],
                      );
                    }
                )
              ],
            ),
          );
        }
    );
  }
}

