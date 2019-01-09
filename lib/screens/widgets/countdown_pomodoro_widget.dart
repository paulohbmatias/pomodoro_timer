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
  const CountDownPomodoroWidget(this.bloc, this.height, this.width);

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
                radius: width/1.3,
                lineWidth: 20.0,
                percent: bloc.percent/100,
                backgroundColor: Colors.green,
                progressColor: Color.fromARGB(255, 229, 22, 22),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data,
                      style: TextStyle(
                          fontSize: 50.0,
                          color: colorTextIcons,
                          fontFamily: 'Digitalism'
                      ),
                    ),
                    SizedBox(height: 8),
                    ListPomodoros(pomodoros: bloc.pomodoros)
                  ],
                ),
              );
            }
        ),
        Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                      stream: bloc.isRunning,
                      initialData: false,
                      builder: (context, snapshot){
                        return InkWell(
                          child: SvgPicture.asset(
                            'assets/${snapshot.data ? 'pause' : 'play'}.svg',
                            color: Colors.white,
                            height: 60,
                          ),
                          onTap: snapshot.data ? bloc.pauseCountDown : bloc.startCountDown,
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
                                height: 60,
                              ),
                              onTap: bloc.stopCountDown,
                            )
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
