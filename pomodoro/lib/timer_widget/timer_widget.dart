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
        0, "Time Break"," Take a break and then keep working!",
        generalNotificationDetails, payload: "Time Break ");
  }
  // fim notification

  int _cycleIndex = 0;
  bool _timeOn = false;
  var _seconds = [1500,300,1500];
  String _timerString = "25:00";
  Timer _timer;

  void _cycleSwitch(){
    switch(_cycleIndex){
      case 0:{setState(() {
        _cycleIndex = 1;
      });}
      break;
      case 1:{setState(() {
        _cycleIndex = 2;
      });}
      break;
      case 2:{setState(() {
        _cycleIndex = 0;
      });}
      break;
    }
  }
   void _endTimer(){
    setState(() {
      _showNotification();
      _cycleSwitch();
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
            Icon(Icons.timer_rounded, color:Colors.amber[800],size: 80),
            Container(height: 50),
            Text(_timerString,style:TextStyle(color: Colors.amber[800], decoration: TextDecoration.none)),
            Container(height: 45),
            OutlineButton(
              color: Colors.amber[800],
              highlightColor:Colors.amber[800].withOpacity(0.3),
              highlightedBorderColor:Colors.amber[800],
              textColor: Colors.amber[800],
              child: Text("Start",style: TextStyle(fontSize: 24)),
              onPressed: () => _timeOnTogle(),
            )
          ],
        ),
      ),
    );
  }

}