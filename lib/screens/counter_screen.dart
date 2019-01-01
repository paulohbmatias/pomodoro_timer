import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';

class CounterScreen extends StatefulWidget {
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> with TickerProviderStateMixin{

  static const int kStartValue = 25;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularPercentIndicator(
            radius: 300.0,
            lineWidth: 20.0,
            percent: 0.2,
            center: StreamBuilder(
                stream: bloc.timer,
                initialData: "25 : 00",
                builder: (context, snapshot){
                  return Text(
                    snapshot.data,
                    style: TextStyle(fontSize: 40.0),
                  );
                }
            ),
            progressColor: Colors.green,
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: RaisedButton(
                child: Text("Start"),
                shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.solid)),
                onPressed: bloc.initCountDown
            ),
          )
        ],
      ),
    );
  }
}
