import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
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

  bool _timeOn = false;
  int _seconds = 20;
  String _timerString = "25:00";
  Timer _timer;

  void _startTimer(){
    _timer = Timer.periodic(Duration(milliseconds: 900), (timer) {
      setState(() {
        if(_seconds >= 0){
          _timerString = _converterSeconds(_seconds);
          _seconds --;
        }else{
          _timer.cancel();
          _showNotification();
        }
      });
    });
  }
  void _timeTogle(){
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
            onPressed: () => _timeTogle(),
          )
        ],
      ),
    );
  }
  
}