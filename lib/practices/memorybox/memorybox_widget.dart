import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MemoryBoxWidget extends StatefulWidget {
  @override
  _MemoryBoxWidgetState createState() => _MemoryBoxWidgetState();
}

class _MemoryBoxWidgetState extends State<MemoryBoxWidget>
    with SingleTickerProviderStateMixin {
  int _counter = 3, level = 0, clickCount = 0, lastBox;
  bool starter = false, ready = false, _visibleMsg =false;
  Timer tipsTimer;
  Random random = new Random();
  String msgText = '';
  var clickedBoxes, generatedBoxes;
  List<int> levelBoxCounts = [4, 4, 5, 5, 5, 6, 6, 6, 7, 7];
  var tapColor = new List.generate(8, (_) => new List(8));

  Future initData() async {
    await Future.delayed(Duration(seconds: 3));
  }

  List<TableRow> _getTableRows() {
    return List.generate(8, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(8, (int colNumber) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 1.0,
              color: Colors.blueGrey,
            ),
            bottom: BorderSide(
              width: 1.0,
              color: Colors.blueGrey,
            ),
            left: BorderSide(
              width: 1.0,
              color: Colors.blueGrey,
            ),
            top: BorderSide(
              width: 1.0,
              color: Colors.blueGrey,
            ),
          ),
        ),
        child: tableCell(rowNumber, colNumber),
      );
    });
  }

  InkResponse tableCell(row, col) {
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        if(ready && (lastBox == (8 * (row) + col))) {
          setState(() {
            tapColor[row][col] = Colors.white70;
          });
          clickCount--;
          clickedBoxes[clickedBoxes.indexOf(lastBox)] = null;
          lastBox = clickedBoxes[clickCount];
          print(clickCount);
          print(clickedBoxes);
        } else if (ready && clickCount<levelBoxCounts[level-1] && (!clickedBoxes.contains(8 * (row) + col))) {
          clickedBoxes[clickCount] = 8 * (row) + col;
          lastBox = clickedBoxes[clickCount];
          setState(() {
            tapColor[row][col] = Colors.orange[300];
          });
          clickCount++;
          print(clickCount);
          print(clickedBoxes);
        }
      },
      child: SizedBox(
        width: 25,
        height: 25,
        child: Container(
          color: tapColor[row][col],
        ),
      ),
    );
  }

  int numberGenerator() {
    int generatedNumber;
    generatedNumber = random.nextInt(64);
    if (generatedBoxes.contains(generatedNumber)) {
      return numberGenerator();
    } else {
      return generatedNumber;
    }
  }

  void paintbox(maxTick){
    int row, col;
    bool colored = false;
    tipsTimer = new Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (tipsTimer.tick == maxTick) {
        tipsTimer.cancel();
        ready = true;
        setState(() {
          msgText = '';
          _visibleMsg = false;
        });
      }
      if (!colored) {
        for (int i = 0; i < levelBoxCounts[level - 1]; i++) {
          row = generatedBoxes[i] ~/ 8;
          col = generatedBoxes[i] % 8;
          tapColor[row][col] = Colors.orange[300];
        }
        setState(() {
          tapColor = tapColor;
        });
        colored = !colored;
      } else {
        for (int i = 0; i < levelBoxCounts[level - 1]; i++) {
          row = generatedBoxes[i] ~/ 8;
          col = generatedBoxes[i] % 8;
          tapColor[row][col] = Colors.white70;
        }
        setState(() {
          tapColor = tapColor;
        });
        colored = !colored;
      }
    });
  }

  void clearMod() {
    clickCount = 0;
    clickedBoxes = new List(levelBoxCounts[level - 1]);
    lastBox = null;
    setState(() {
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          setState(() {
            tapColor[i][j] = Colors.white70;
          });
        }
      }
    });
  }

  void levelGenerator() {
    setState(() {
      level++;
    });
    if(level>1) clearMod();
    generatedBoxes = new List(levelBoxCounts[level - 1]);
    clickedBoxes = new List(levelBoxCounts[level - 1]);
    for (int i = 0; i < levelBoxCounts[level - 1]; i++) {
      generatedBoxes[i] = numberGenerator();
    }
    paintbox(12);
    print(generatedBoxes);

  }

  @override
  void initState() {
    super.initState();
    initData().then((_) {
      levelGenerator();
      setState(() {
        //start memory box
        starter = true;
        for (int i = 0; i < 8; i++) {
          for (int j = 0; j < 8; j++) {
            setState(() {
              tapColor[i][j] = Colors.white70;
            });
          }
        }
      });
    });
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _counter--;
        if (_counter == 0) {
          timer.cancel();
        }
      });
    });
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
                  'MEMORY BOX',
                  style: TextStyle(fontSize: 30, color: Colors.white30),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: StepProgressIndicator(
                    totalSteps: 10,
                    currentStep: level,
                    size: 15,
                    selectedColor: Colors.orangeAccent,
                    unselectedColor: Colors.white54,
                    roundedEdges: Radius.circular(10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  color: Colors.transparent,
                  height: 230,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Table(
                      border: TableBorder(
                        top: BorderSide(width: 3.0, color: Colors.blueGrey),
                        right: BorderSide(width: 3.0, color: Colors.blueGrey),
                        left: BorderSide(width: 3.0, color: Colors.blueGrey),
                        bottom: BorderSide(width: 3.0, color: Colors.blueGrey),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: _getTableRows(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blueGrey),
                      ),
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      textColor: Colors.blueGrey,
                      onPressed: () {
                        //if wrong
                        generatedBoxes.sort();
                        clickedBoxes.sort();
                        if(listEquals(generatedBoxes, clickedBoxes)) {
                          setState(() {
                            msgText = 'Great! Keep on...';
                            _visibleMsg = true;
                          });
                          levelGenerator();
                        } else {
                          setState(() {
                            msgText = 'Nice try. But not enough...';
                            _visibleMsg = true;
                          });
                          levelGenerator();
                        }
                      },
                      icon: Icon(Icons.check),
                      label: Text(
                        'Check ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blueGrey),
                      ),
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      textColor: Colors.blueGrey,
                      onPressed: () {
                        clearMod();
                      },
                      icon: Icon(Icons.clear),
                      label: Text(
                        'Clear ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 16,
                ),
                AnimatedOpacity(
                  opacity: _visibleMsg ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1500),
                  child: Text(
                    msgText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  '$_counter',
                  key: ValueKey<int>(_counter),
                  style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
    );
  }
}
