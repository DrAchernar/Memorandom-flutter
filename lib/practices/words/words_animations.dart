import 'package:flutter/material.dart';

class AnimationCollection {
  Widget stackWords(controller, context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).size.height / 8,
          right: MediaQuery.of(context).size.width / 7,
          child: SizeTransition(
            child: Text(
              'white',
              style: TextStyle(color: Colors.white70, fontSize: 24),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[0],
                reverseCurve: Curves.elasticIn),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4,
          right: MediaQuery.of(context).size.width / 2,
          child: SizeTransition(
            child: Text(
              'black',
              style: TextStyle(color: Colors.black54, fontSize: 35),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[1],
                reverseCurve: Curves.elasticIn),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.45,
          right: MediaQuery.of(context).size.width / 2,
          child: SizeTransition(
            child: Text(
              'red',
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[2],
                reverseCurve: Curves.elasticIn),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.92,
          right: MediaQuery.of(context).size.width / 8,
          child: SizeTransition(
            child: Text(
              'blue',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[3],
                reverseCurve: Curves.elasticIn),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.75,
          right: MediaQuery.of(context).size.width / 1.55,
          child: SizeTransition(
            child: Text(
              'green',
              style: TextStyle(color: Colors.green, fontSize: 40),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[4],
                reverseCurve: Curves.elasticIn),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 5.5,
          right: MediaQuery.of(context).size.width / 1.45,
          child: SizeTransition(
            child: Text(
              'yellow',
              style: TextStyle(color: Colors.yellow, fontSize: 16),
            ),
            sizeFactor: CurvedAnimation(
                curve: Curves.elasticOut,
                parent: controller[5],
                reverseCurve: Curves.elasticIn),
          ),
        ),
      ],
    );
  }

  TweenSequence setTween() {
    return TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.green[200],
          end: Colors.blue[300],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue[300],
          end: Colors.red[400],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.red[400],
          end: Colors.yellow[300],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.yellow[300],
          end: Colors.pink[300],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.pink[300],
          end: Colors.green[200],
        ),
      ),
    ]);
  }
}
