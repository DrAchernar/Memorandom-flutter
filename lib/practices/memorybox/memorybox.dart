import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:memorandom/practices/memorybox/memorybox_widget.dart';

// ignore: must_be_immutable
class MemoryBox extends StatefulWidget {
  bool started;

  MemoryBox({Key key, this.started});

  @override
  _MemoryBoxState createState() => _MemoryBoxState();
}

class _MemoryBoxState extends State<MemoryBox> with TickerProviderStateMixin {
  var boxColor = new List(80);
  final random = new Random();
  Timer timerColorize;

  void colorizeBox() {
    for (int i = 0; i < 80; i++) {
      setState(() {
        boxColor[i] = Colors.white24;
      });
    }
    timerColorize = new Timer.periodic(Duration(seconds: 2), (Timer timer) {
      for (int i = 0; i < 5; i++) {
        boxColor[random.nextInt(80)] = Color.fromRGBO(255, 165, 0, 0.7);
      }
      for (int i = 0; i < 10; i++) {
        boxColor[random.nextInt(80)] = Colors.white24;
      }
      setState(() {
        boxColor = boxColor;
      });
    });
  }

  @override
  void initState() {
    colorizeBox();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    timerColorize.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Memorandom'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        automaticallyImplyLeading: false,
        gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.green[200]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        actions: <Widget>[
          widget.started ?
          FlatButton(
            child: Text(
              'Restart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MemoryBox(
                      started: true,
                    );
                  }));
            },
          ) : SizedBox(),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[200], Colors.blue])),
          child: widget.started ? MemoryBoxWidget() : Stack(
            children: <Widget>[
              Positioned(
                top: height / 73,
                width: width,
                child: Text(
                  'MEMORY BOX',
                  style: TextStyle(fontSize: 30, color: Colors.white30),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: height / 10,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 50,
                child: Container(
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 8,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(80, (index) {
                      return GestureDetector(
                        onTap: () {
                          print(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: boxColor[index]),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(75),
                        side: BorderSide(color: Colors.white),
                      ),
                      textColor: Colors.blue,
                      color: Colors.green[100],
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        'GO!',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        timerColorize.cancel();
                        setState(() {
                          widget.started = true;
                        });
                      },
                    )),
              ),
            ],
          )),
    );
  }
}
