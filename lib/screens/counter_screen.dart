import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';

class CounterScreen extends StatefulWidget {
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<String>(
            stream: bloc.timer,
            initialData: "25 : 00",
            builder: (context, snapshot){
              return CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width - 30,
                lineWidth: 20.0,
                percent: bloc.percent/100,
                center: Text(
                  snapshot.data,
                  style: TextStyle(fontSize: 40.0),
                ),
                progressColor: Colors.green,
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
                    Image.asset('icons/tomato_fill.png'),
                    Image.asset('icons/tomato_fill.png'),
                    Image.asset('icons/tomato.png'),
                    Image.asset('icons/tomato.png'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder(
                        stream: bloc.isRunning,
                        initialData: false,
                        builder: (context, snapshot){
                          return IconButton(
                            icon: Icon(snapshot.data ? Icons.pause : Icons.play_arrow),
                            onPressed: snapshot.data ? bloc.pauseCountDown : bloc.initCountDown,
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
    );
  }
}
