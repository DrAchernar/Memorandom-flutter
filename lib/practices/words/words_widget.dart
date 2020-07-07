import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorldsWidget extends StatefulWidget {
  @override
  _WorldsWidgetState createState() => _WorldsWidgetState();
}

class _WorldsWidgetState extends State<WorldsWidget>
    with SingleTickerProviderStateMixin {
  int _counter = 3, countdown = 60, passingTime = 0;
  bool starter = false;
  Timer timerCountdown;
  String username = '';
  int bestScore = 0, lastScore = 0;
  Color textColor = Colors.white;
  String text = 'Loading';
  var swatchControl = Icons.pause_circle_outline;
  List<Color> colors = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.black,
  ];
  List<String> words = ['green', 'red', 'blue', 'black'];

  Future initData() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Future getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      if (prefs.get('bestScore') != '' && prefs.get('bestScore') != null) {
        bestScore = prefs.get('bestScore');
      }
    });
  }

  void playPauseIconChange() {
    if (countdown > 0) {
      if (timerCountdown.isActive) {
        setState(() {
          swatchControl = Icons.play_circle_outline;
          timerCountdown.cancel();
        });
      } else {
        setState(() {
          swatchControl = Icons.pause_circle_outline;
          timerControl();
        });
      }
    }
  }

  void generateColoredWord() {
    final random = new Random();
    setState(() {
      textColor = colors[random.nextInt(4)];
      text = words[random.nextInt(4)];
    });
  }

  void timerControl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    timerCountdown = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        countdown--;
        passingTime++;
        if (countdown == 0) {
          swatchControl = Icons.play_circle_outline;
          timer.cancel();
          if (lastScore > bestScore) {
            prefs.setInt('bestScore', lastScore);
            bestScore = lastScore;
            print('Great! You have best score...');
          }
          //finish
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    initData().then((_) {
      setState(() {
        generateColoredWord();
        starter = true;
      });
    });
    //3-2-1 countdown before start game
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _counter--;
        if (_counter == 0) {
          timer.cancel();
          timerControl();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timerCountdown.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[200], Colors.blue])),
        padding: EdgeInsets.only(top: height / 73),
        alignment: Alignment.topCenter,
        child: starter
            ? Column(
                children: <Widget>[
                  Text(
                    'COLORS AND WORDS',
                    style:
                    TextStyle(fontSize: 30, color: Colors.white30),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 30, right: 10, bottom: 10, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20),
                          color: Colors.white70,
                          height: 90,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: Text(
                                  '$text',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                ),
                                child: Divider(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$lastScore Points',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Center(
                          child: IconButton(
                              padding: EdgeInsets.only(right: width / 30),
                              icon: Icon(
                                swatchControl,
                                color: Colors.blueGrey[400],
                                size: 40,
                              ),
                              onPressed: () {
                                playPauseIconChange();
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 30,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              color: Colors.blueGrey[50],
                              onPressed: () {
                                if (colors.indexOf(textColor) ==
                                    words.indexOf(text)) {
                                  setState(() {
                                    lastScore = lastScore +
                                        (10 / (passingTime + 1)).truncate();
                                  });
                                  passingTime = 0;
                                }
                                generateColoredWord();
                              },
                            ),
                            RaisedButton(
                              child: Icon(
                                Icons.do_not_disturb,
                                color: Colors.orange,
                                size: 30,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              color: Colors.blueGrey[50],
                              onPressed: () {
                                if (colors.indexOf(textColor) !=
                                    words.indexOf(text)) {
                                  setState(() {
                                    lastScore = lastScore +
                                        (10 / (passingTime + 1)).truncate();
                                  });
                                  passingTime = 0;
                                }
                                generateColoredWord();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      height: height / 18,
                      width: width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white10,
                      ),
                      child: Center(
                        child: Text(
                          '$countdown Seconds...',
                          style: TextStyle(color: Colors.blueGrey[700]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        '$username\'s best score: $bestScore',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: Text(
                    '$_counter',
                    // This key causes the AnimatedSwitcher to interpret this as a "new"
                    // child each time the count changes, so that it will begin its animation
                    // when the count changes.
                    key: ValueKey<int>(_counter),
                    style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ));
  }
}
