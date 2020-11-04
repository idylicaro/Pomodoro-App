import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerWidget extends StatefulWidget {
  final String title;
  const TimerWidget({Key key, this.title}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await flutterLocalNotificationsPlugin.show(
        0, _getNameNotification(),_getTextNotification(),
        generalNotificationDetails, payload: _getNameNotification());
  }
  // fim notification
  static var _secondsBaseCycleRestart = [1500,300];
  int _cycleIndex = 0; // current index in cycle (focusing or time break
  int _countCycles = 0;
  bool _timeOn = false;
  var _seconds = [1500,300];
  String _timerString = "25:00";
  Timer _timer;


  String _getTextNotification(){
    if(_cycleIndex != 1)
      return "Take a break";
    return "Let's focusing again";
  }
  String _getNameNotification(){
    if(_cycleIndex != 1)
      return "Time break!";
    return "Focusing!";
  }

  String _getTextStatusOfCycle(){
    if(_cycleIndex != 1)
      return "Focusing!";
    return "Time break!";
  }
  String _getTextStatusOfButton(){
    if(_timeOn == true)
      return "Pause";
    return "Play";
  }

  void _cycleSwitch(){
    switch(_cycleIndex){
      case 0:{setState(() {
        _cycleIndex = 1;
        _countCycles++;
        if(_countCycles == 4){ // get long break time
          _seconds[_cycleIndex] = 1800;
        }
      });}
      break;
      case 1:{setState(() {
        if(_countCycles == 4){ // get long break time
          _seconds[_cycleIndex] = _secondsBaseCycleRestart[_cycleIndex];
          _countCycles = 0;
        }
        _cycleIndex = 0;
      });}
      break;
    }
  }

   void _endTimer(){
    setState(() {
      _showNotification();
      _seconds[_cycleIndex] = _secondsBaseCycleRestart[_cycleIndex];
      _cycleSwitch();
      _timeOn = false;
    });
   }

  void _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_seconds[_cycleIndex] >= 0){
          _timerString = _converterSeconds(_seconds[_cycleIndex]);
          _seconds[_cycleIndex] --;
        }else{
          _timer.cancel();
          _endTimer();
        }
      });
    });
  }

  void _timeOnTogle(){
    setState(() {
      _timeOn = !_timeOn;
    });
    if (!_timeOn) _pauseTimer(); else _startTimer();
  }

  void _pauseTimer(){
    setState(() {
      _timeOn = false;
      _timer.cancel();
    });
  }

  String _converterSeconds(int seconds){
    int _mm,_ss;
    _ss = seconds % 60;
    seconds = seconds ~/ 60;
    _mm = seconds % 60;
    return "$_mm:$_ss";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(50.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.amber[800]),
            borderRadius: BorderRadius.circular(24)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_getTextStatusOfCycle(),style:TextStyle(color: Colors.amber[800], decoration: TextDecoration.none,fontSize: 24)),
            Container(height: 30),
            Icon(Icons.timer_rounded, color:Colors.amber[800],size: 80),
            Container(height: 50),
            Text(_timerString,style:TextStyle(color: Colors.amber[800], decoration: TextDecoration.none)),
            Container(height: 45),
            OutlineButton(
              color: Colors.amber[800],
              highlightColor:Colors.amber[800].withOpacity(0.3),
              highlightedBorderColor:Colors.amber[800],
              textColor: Colors.amber[800],
              child: Text(_getTextStatusOfButton(),style: TextStyle(fontSize: 24)),
              onPressed: () => _timeOnTogle(),
            )
          ],
        ),
      ),
    );
  }

}