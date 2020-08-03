import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:memorandom/pages/trainer.dart';

class Sudoku extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  int pRow, pCol, uRow, uCol;
  bool cleanable = false;
  var board, solve;
  String checkBoard;
  bool isLoading = true;
  var boardCell = new List.generate(9, (_) => new List(9));
  var tapColor = new List.generate(9, (_) => new List(9));
  List<dynamic> disabledCell = new List();
  List<dynamic> enableNums = new List();

  @override
  void initState() {
    super.initState();
    getBoard();
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        setState(() {
          boardCell[i][j] = '';
          tapColor[i][j] = Colors.grey[100];
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  errorDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Connection problem!'),
                Text('Check your internet connection.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trainer()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void getBoard() async {
    disabledCell.clear();
    enableNums = [];
    var responseBoard, responseSolver;
    if (pRow != null) tapColor[pRow][pCol] = Colors.grey[100];
    try {
      responseBoard = await http
          .get("https://agarithm.com/sudoku/new")
          .timeout(Duration(seconds: 7));
      if (responseBoard.statusCode == 200 && this.mounted) {
        board = responseBoard.body;
        responseSolver =
            await http.get("https://agarithm.com/sudoku/solve/$board");
        if (responseSolver.statusCode == 200) {
          solve = responseSolver.body;
        }
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            setState(() {
              if (board[i * 9 + j] == '.') {
                boardCell[i][j] = '';
              } else {
                disabledCell.add(i * 9 + j);
                boardCell[i][j] = (board[i * 9 + j]).toString();
              }
            });
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (e) {
      errorDialog();
    } on SocketException catch (e) {
      errorDialog();
    } on Error catch (e) {
      errorDialog();
    }
  }

  List<TableRow> _getTableRows() {
    return List.generate(9, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(9, (int colNumber) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: (colNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: (rowNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
          ),
        ),
        child: sudokuCell(rowNumber, colNumber),
      );
    });
  }

  InkResponse sudokuCell(row, col) {
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        enableNums = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
        setState(() {
          if (!disabledCell.contains((row * 9) + col)) {
            if (pRow != null) {
              tapColor[pRow][pCol] = Colors.grey[100];
            }
            cleanable = true;
            pRow = row;
            pCol = col;
            tapColor[row][col] = Colors.indigoAccent[100];
            for (int i = 0; i < 9; i++) {
              if (row != i && enableNums.contains(boardCell[i][col])) {
                bool res = enableNums.remove('${boardCell[i][col]}');
              }
              if (col != i) {
                bool res = enableNums.remove('${boardCell[row][i]}');
              }
            }
          } else {
            enableNums = [];
            if (pRow != null) tapColor[pRow][pCol] = Colors.grey[100];
          }
        });
      },
      child: SizedBox(
        width: 25,
        height: 30,
        child: Container(
          color: tapColor[row][col],
          child: Center(
            child: Text(boardCell[row][col].toString()),
          ),
        ),
      ),
    );
  }

  void undoLast(row, col) {
    if (row != null && col != null) {
      setState(() {
        disabledCell.removeLast();
        boardCell[row][col] = '';
      });
    }
  }

  void insertToCell(number, row, col) {
    uRow = row;
    uCol = col;
    setState(() {
      disabledCell.add(row * 9 + col);
      boardCell[row][col] = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //print('height : $height --- width : $width');
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Memoraks'),
        gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.green[200]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (!isLoading) {
                Navigator.of(context).pop();
              }
            }),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'New',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              getBoard();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[200], Colors.blue])),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'SUDOKU',
                style: TextStyle(fontSize: 20, color: Colors.white30),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: height / 14, right: width / 41, left: width / 41),
              child: Table(
                border: TableBorder(
                  left: BorderSide(width: 3.0, color: Colors.black),
                  top: BorderSide(width: 3.0, color: Colors.black),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _getTableRows(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  right: width / 20, left: width / 20, bottom: height / 20),
              margin: EdgeInsets.only(top: height / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                      onPressed: () {
                        undoLast(uRow, uCol);
                      },
                      textColor: Colors.white,
                      color: Colors.blueGrey,
                      icon: Icon(Icons.settings_backup_restore),
                      label: new Text('Undo Last')),
                  Text(
                    'Available numbers',
                    style: TextStyle(color: Colors.black38),
                  ),
                  isLoading
                      ? Container(
                          height: height / 7,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Please wait! \n SUDOKU IS GENERATING...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : SizedBox(
                          height: height / 7,
                          child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: enableNums.length,
                              itemBuilder: (BuildContext context, int Index) {
                                return new Container(
                                  alignment: Alignment.topCenter,
                                  height: height / 18,
                                  width: width / 10,
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 20),
                                  child: FlatButton(
                                    onPressed: () {
                                      insertToCell(
                                          enableNums[Index], pRow, pCol);
                                    },
                                    child: Text(
                                      enableNums[Index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    color: Colors.white,
                                    highlightColor: Colors.indigo,
                                  ),
                                );
                              })),
                  isLoading
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton.icon(
                              padding: const EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              color: Colors.lightGreen,
                              onPressed: () {
                                checkBoard = '';
                                for (int i = 0; i < 9; i++) {
                                  for (int j = 0; j < 9; j++) {
                                    if (boardCell[i][j] == '') {
                                      boardCell[i][j] = '.';
                                    }
                                    checkBoard =
                                        checkBoard + boardCell[i][j].toString();
                                  }
                                }
                                if (checkBoard == solve) {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Congratulations'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('You succeeded.'),
                                              Text(
                                                  'You can start a new sudoku using New button or try other practices.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Cannot Solved!'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Please check your sudoku...'),
                                              Text('Clear and try again.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              icon: Icon(Icons.check_circle_outline),
                              label: new Text("Solve! "),
                            ),
                            new RaisedButton.icon(
                              onPressed: () {
                                if (cleanable) {
                                  disabledCell.clear();
                                  enableNums = [];
                                  setState(() {
                                    for (int i = 0; i < 9; i++) {
                                      for (int j = 0; j < 9; j++) {
                                        setState(() {
                                          if (board[i * 9 + j] == '.') {
                                            boardCell[i][j] = '';
                                          } else {
                                            disabledCell.add(i * 9 + j);
                                            boardCell[i][j] =
                                                (board[i * 9 + j]).toString();
                                          }
                                        });
                                      }
                                    }
                                    cleanable = false;
                                  });
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Oops!'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'The board is already clear!'),
                                              Text(''),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              textColor: Colors.white,
                              color: Colors.orangeAccent,
                              padding: const EdgeInsets.all(8.0),
                              icon: Icon(Icons.clear),
                              label: new Text(
                                "Clear ",
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
