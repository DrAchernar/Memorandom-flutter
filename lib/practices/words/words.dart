import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:quiver/async.dart';
import 'package:memorandom/practices/words/words_animations.dart';
import 'package:memorandom/practices/words/words_widget.dart';

// ignore: must_be_immutable
class ColorsAndWords extends StatefulWidget {
  bool started;

  ColorsAndWords({Key key, this.started});

  @override
  _ColorsAndWordsState createState() => _ColorsAndWordsState();
}

class _ColorsAndWordsState extends State<ColorsAndWords>
    with TickerProviderStateMixin {
  int currentTime = 60;
  String countdown = '';
  AnimationController _controller;
  List<AnimationController> controller = new List(6);
  Timer timer1;

  void timerStarter() {
    CountdownTimer(Duration(seconds: 60), Duration(seconds: 1))
        .listen((data) {})
          ..onData((data) {
            currentTime--;
            setState(() {
              countdown = '$currentTime seconds remained';
            });
          })
          ..onDone(() {
            setState(() {
              countdown = 'Finished.';
            });
          });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 6; i++) {
      controller[i] =
          AnimationController(vsync: this, duration: Duration(seconds: 5));
    }
    timer1 = Timer.periodic(Duration(seconds: 2), (timer) {
      controller[timer.tick - 1].forward();
      if (timer.tick == 6) timer.cancel();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 13),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    timer1.cancel();
    _controller.dispose();
    for (int i = 0; i < 6; i++) {
      controller[i].dispose();
    }
    super.dispose();
  }

  Animatable<Color> background =
      AnimationCollection().setTween() as Animatable<Color>;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            appBar: GradientAppBar(
              title: Text('Memorandom'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _controller.stop();
                    Navigator.of(context).pop();
                  }),
              automaticallyImplyLeading: false,
              gradient: LinearGradient(
                  colors: [Colors.blue[300], Colors.green[200]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              actions: <Widget>[
                widget.started
                    ? FlatButton(
                        child: Text(
                          'Restart',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ColorsAndWords(
                              started: true,
                            );
                          }));
                        },
                      )
                    : SizedBox(),
              ],
            ),
            body: Container(
              color: background
                  .evaluate(AlwaysStoppedAnimation(_controller.value)),
              child: widget.started
                  ? Stack(
                      children: <Widget>[
                        WorldsWidget(),
                        SizedBox(
                          height: 50,
                        ),
                        Text('$countdown'),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'COLORS AND WORDS',
                            style:
                                TextStyle(fontSize: 30, color: Colors.white30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AnimationCollection().stackWords(controller, context),
                        //Positioned.fill(child: AnimatedBackground()),
                        //Positioned.fill(child: Particles(30)),
                        Positioned.fill(
                          child: Center(
                              child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(75),
                              side: BorderSide(color: Colors.white),
                            ),
                            textColor: Colors.orangeAccent,
                            color: Colors.white,
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              'Start!',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              timer1.cancel();
                              _controller.reset();
                              setState(() {
                                widget.started = true;
                              });
                            },
                          )),
                        ),
                      ],
                    ),
            ),
          );
        });
  }
}
