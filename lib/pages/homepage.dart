import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:memorandom/welcome/login_intro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memorandom/pages/trainer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _visibleM1 = false;
  bool _visibleM2 = false;

  bool isLoggedIn = false;
  String name = '';

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        name = userId;
        Navigator.of(context).push(_createRoute(Trainer()));
      });
      return;
    } else {
      Navigator.of(context).push(_createRoute(LoginSession()));
    }
  }

  Route _createRoute(page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _visibleM1 = true;
      });
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        _visibleM1 = false;
        _visibleM2 = true;
      });
    });
    Timer(Duration(seconds: 5), () {
      autoLogIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Memoraks'),
        gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.green[200]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[200], Colors.blue])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _visibleM1 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1500),
              child: Text(
                'Hello',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                  color: Colors.grey[800],
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _visibleM2 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1500),
              child: Text(
                'Welcome to Memoraks',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
