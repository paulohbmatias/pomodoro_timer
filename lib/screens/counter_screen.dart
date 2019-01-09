import 'package:flutter/material.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';
import 'package:pomodoro_timer/screens/settings_screen.dart';
import 'package:pomodoro_timer/screens/widgets/bottom_sheet_widget.dart';
import 'package:pomodoro_timer/screens/widgets/countdown_pomodoro_widget.dart';

class CounterScreen extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double height;
  double width;
  int bottomPage;

  @override
  Widget build(BuildContext context) {
    bloc.initCountDown();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 35, 31, 32),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 35, 31, 32),
        elevation: 0,
        leading: StreamBuilder(
            stream: bloc.isBottomSheetOpen,
            initialData: false,
            builder: (context, snapshot){
              return snapshot.data ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){
                    Navigator.of(context).pop();
                    bloc.changeIsBottomSheetOpen(false);
                  }
              ) : Container();
            }
        ),
        actions: <Widget>[
          StreamBuilder(
              stream: bloc.isBottomSheetOpen,
              initialData: false,
              builder: (context, snapshot){
                return !snapshot.data ? Container(
                  margin: EdgeInsets.all(16),
                  child: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: (){
                        bloc.changeIsBottomSheetOpen(true);
                        _scaffoldKey.currentState.showBottomSheet(
                                (context) => SettingsScreen(bloc: bloc,)
                        );
                      }
                  ),
                ) : Container();
              }
          )
        ],
      ),
      body: CountDownPomodoroWidget(bloc, height, width),
      bottomNavigationBar: BottomSheetPomodoro(bloc),
    );
  }
}

