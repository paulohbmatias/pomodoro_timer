import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';

class CounterScreen extends StatefulWidget {
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> with TickerProviderStateMixin{

  final colorTextIcons = Colors.white;
//  final colorTextIcons = Color.fromARGB(255, 209,56,52);
  double height;
  double width;
  int bottomPage;

  @override
  void initState() {
    bloc.initCountDown();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 31, 32),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 35, 31, 32),
        elevation: 0,
        actions: <Widget>[
          Icon(Icons.settings)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<String>(
            stream: bloc.timer,
            initialData: "",
            builder: (context, snapshot){
              return CircularPercentIndicator(
                radius: width/1.2,
                lineWidth: 20.0,
                percent: bloc.percent/100,
                backgroundColor: Colors.green,
                progressColor: Colors.red,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data,
                      style: TextStyle(
                        fontSize: 60.0,
                        color: colorTextIcons,
                        fontFamily: 'Digitalism'
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: getPomodoros(bloc.pomodoros),
                    )
                  ],
                ),
              );
            }
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder(
                        stream: bloc.isRunning,
                        initialData: false,
                        builder: (context, snapshot){
                          return IconButton(
                            icon: Icon(snapshot.data ? Icons.pause : Icons.play_arrow),
                            color: colorTextIcons,
                            onPressed: snapshot.data ? bloc.pauseCountDown : bloc.startCountDown,
                            iconSize: 60,
                          );
                        }
                    ),
                    StreamBuilder(
                        stream: bloc.isStarted,
                        initialData: false,
                        builder: (context, snapshot){
                          return Visibility(
                            visible: snapshot.data ? true : false,
                            child: IconButton(
                              icon: Icon(Icons.stop),
                              color: colorTextIcons,
                              onPressed: bloc.stopCountDown,
                              iconSize: 60,
                            ),
                          );
                        }
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: bloc.page,
        initialData: 0,
        builder: (context, snapshot){
          return BottomNavigationBar(
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
      ),
    );
  }

  List<Widget> getPomodoros(int pomodoros){
    List<Widget> list = List();
    for(int i = 1; i <= 4; i++){
      if(i <= pomodoros)
        list.add(Image.asset('icons/tomato_fill.png'));
      else
        list.add(Image.asset('icons/tomato.png', color: Colors.white,));
      list.add(SizedBox(width: 8,));
    }
    list.removeLast();
    return list;
  }
}
