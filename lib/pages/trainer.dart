import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:memorandom/pages/info.dart';
import 'package:memorandom/practices/sudoku/sudoku.dart';
import 'package:memorandom/practices/memorybox/memorybox.dart';
import 'package:memorandom/practices/words/words.dart';
import 'package:memorandom/practices/memorybox/memorybox_howtoplay.dart';
import 'package:memorandom/practices/sudoku/sudoku_howtoplay.dart';
import 'package:memorandom/practices/words/words_howtoplay.dart';

class Trainer extends StatefulWidget {
  @override
  _TrainerState createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Info());
              })
        ],
        title: Text('Memoraks'),
        automaticallyImplyLeading: false,
        gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.green[200]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[200], Colors.blue])),
          child: Column(
            children: <Widget>[
              Card(
                  child: Container(
                height: MediaQuery.of(context).size.height / 4,
                color: Colors.lightGreen[200],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        Icons.apps,
                        size: 50,
                        color: Colors.white,
                      ),
                      title: Text(
                        'SUDOKU',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Train your brain with numbers.'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            'How to Play',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Sudoku_Info());
                          },
                        ),
                        FlatButton(
                          child: const Text(
                            'PLAY',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            /* ... */
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Sudoku()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  color: Colors.lightBlueAccent[100],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(
                          Icons.format_color_text,
                          size: 50,
                          color: Colors.white,
                        ),
                        title: Text(
                          'COLORS & WORDS',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Test how careful you are.'),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text(
                              'How to Play',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Words_Info());
                            },
                          ),
                          FlatButton(
                            child: const Text(
                              'PLAY',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              /* ... */
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ColorsAndWords(
                                          started: false,
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  color: Colors.deepPurpleAccent[200],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(
                          Icons.memory,
                          size: 50,
                          color: Colors.white,
                        ),
                        title: Text(
                          'MEMORY BOX',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Try to remember colored boxes.'),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text(
                              'How to Play',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      MemoryBox_Info());
                            },
                          ),
                          FlatButton(
                            child: const Text(
                              'PLAY',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              /* ... */
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemoryBox(
                                          started: false,
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
