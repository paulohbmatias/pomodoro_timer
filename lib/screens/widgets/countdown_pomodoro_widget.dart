import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_timer/blocs/bloc.dart';
import 'package:pomodoro_timer/screens/widgets/pomodoros_widget.dart';

class CountDownPomodoroWidget extends StatelessWidget {

  final Bloc bloc;
  final double height;
  final double width;
  final colorTextIcons = Colors.white;
  CountDownPomodoroWidget(this.bloc, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<String>(
            stream: bloc.timer,
            initialData: "",
            builder: (context, snapshot){
              return CircularPercentIndicator(
                radius: width < 350 ? (width/1.3) : (width/1.2),
                lineWidth: width < 350 ? 15.0 : 20,
                percent: bloc.percent/100,
                backgroundColor: Color(0xff2abd6c),
                progressColor: Colors.red[500],
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data,
                      style: TextStyle(
                          fontSize: width < 350 ? 40 : 80,
                          color: colorTextIcons,
                          fontFamily: 'Digitalism'
                      ),
                    ),
                    SizedBox(height: 8),
                    ListPomodoros(bloc.pomodoros, width)
                  ],
                ),
              );
            }
        ),
        Container(
          margin: width < 350 ? EdgeInsets.all(10) : EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                      stream: bloc.isRunning,
                      initialData: false,
                      builder: (context, snapshot){
                        return Container(
                          margin: EdgeInsets.only(left: !snapshot.data? 20 : 0),
                          child: InkWell(
                            child: SvgPicture.asset(
                              'assets/${snapshot.data ? 'pause' : 'play'}.svg',
                              color: Colors.white,
                              height: width < 350 ? 55 : 65,
                            ),
                            onTap: snapshot.data ? bloc.pauseCountDown : bloc.startCountDown,
                          ),
                        );
                      }
                  ),
                  SizedBox(width: 20,),
                  StreamBuilder(
                      stream: bloc.isStarted,
                      initialData: false,
                      builder: (context, snapshot){
                        return Visibility(
                            visible: snapshot.data ? true : false,
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/stop.svg',
                                color: Colors.white,
                                height: width < 350 ? 55 : 65,
                              ),
                              onTap: bloc.stopCountDown,
                            )
                        );
                      }
                  ),
//                  FlatButton(
//                      onPressed: bloc.showNotification,
//                      child: Text("Notification")
//                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
