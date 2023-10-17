import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:miniproyecto_02/src/home_page.dart';
import 'package:sqflite/sqflite.dart';

class MemoramaGame extends StatefulWidget {
  int total = 0;
  MemoramaGame({required this.total});
  @override
  _MemoramaGameState createState() => _MemoramaGameState(totalCartas: total);
}

class _MemoramaGameState extends State<MemoramaGame> {
  late String _path;
  late Database database;

  Map<String, dynamic>? nivel1, nivel2, nivel3;
  String? mejorTiempo = "1000";
  String nivel = "";
  int totalCartas = 0;

  _MemoramaGameState({required this.totalCartas});

  List<GlobalKey<FlipCardState>> cardStateKeys = [
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
  ];
  List<bool> cardFlips = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  List<bool> realCardFlips = [];
  List<String> data = [
    "0",
    "0",
    "1",
    "1",
    "2",
    "2",
    "3",
    "3",
    "4",
    "4",
    "5",
    "5"
  ];
  List<String> realData = [];
  List<String> pokemons = [
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png",
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/18.png",
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"
  ];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  late Timer timer;
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  @override
  void initState() {
    _createDB();
    super.initState();

    startTimer();
    realCardFlips = cardFlips.sublist(0, totalCartas);
    realData = data.sublist(0, totalCartas);
    realData.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memorama Pokemon"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Tiempo: $time s",
                    style: Theme.of(context).textTheme.displaySmall)),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Record: $mejorTiempo s",
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            Theme(
              data: ThemeData.dark(),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) => FlipCard(
                    key: cardStateKeys[index],
                    onFlip: () {
                      if (!flip) {
                        flip = true;
                        previousIndex = index;
                      } else {
                        flip = false;
                        if (previousIndex != index) {
                          if (realData[previousIndex] != realData[index]) {
                            cardStateKeys[previousIndex]
                                .currentState
                                ?.toggleCard();

                            previousIndex = index;
                          } else {
                            realCardFlips[previousIndex] = false;
                            realCardFlips[index] = false;

                            if (realCardFlips
                                .every((element) => element == false)) {
                              timer.cancel();
                              if (time < int.parse(mejorTiempo!) ||
                                  int.parse(mejorTiempo!) <= 0) {
                                _updateDB(time, nivel);
                              }
                              showResult(totalCartas);
                            }
                          }
                        }
                      }
                    },
                    direction: FlipDirection.HORIZONTAL,
                    flipOnTouch: realCardFlips[index],
                    front: Container(
                      margin: EdgeInsets.all(4.0),
                      color: Colors.deepOrange.withOpacity(0.3),
                    ),
                    back: Container(
                      margin: EdgeInsets.all(4.0),
                      color: Colors.deepOrange,
                      child: Center(
                          child: Image(
                        image:
                            NetworkImage(pokemons[int.parse(realData[index])]),
                      )),
                    ),
                  ),
                  itemCount: realData.length,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  showResult(total) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Ganaste!!"),
              content: Text("Time: $time",
                  style: Theme.of(context).textTheme.displayMedium),
              actions: <Widget>[
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Regresar"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber, onPrimary: Colors.white),
                ),
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Reiniciar"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MemoramaGame(total: total)));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                )
              ],
            ));
  }

  void _createDB() async {
    var dbpath = await getDatabasesPath();

    _path = '${dbpath}my_db.db';

    database = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY, nivel TEXT, time TEXT)');
    });
    _showDB();
    // await database.transaction((txn) async {
    //   int reg1 = await txn
    //       .rawInsert('INSERT INTO User (nivel, time) VALUES ("nivel1", "0")');
    //   print('Insert: $reg1');
    //   int reg2 = await txn
    //       .rawInsert('INSERT INTO User (nivel, time) VALUES ("nivel2", "0")');
    //   print('Insert: $reg2');
    //   int reg3 = await txn
    //       .rawInsert('INSERT INTO User (nivel, time) VALUES ("nivel3", "0")');
    //   print('Insert: $reg3');
    // });
  }

  void _updateDB(time, nivel) async {
    int upt = await database
        .rawUpdate("UPDATE User SET time = ? WHERE name = ?", [time, nivel]);
    print("Update: $upt");
  }

  void _showDB() async {
    List<Map<String, dynamic>> show =
        await database.rawQuery("SELECT * FROM User");
    nivel1 = show[0];
    nivel2 = show[1];
    nivel3 = show[2];

    if (totalCartas == 8) {
      mejorTiempo = nivel1?["time"];
      nivel = "nivel1";
    } else if (totalCartas == 10) {
      mejorTiempo = nivel2?["time"];
      nivel = "nivel2";
    } else if (totalCartas == 12) {
      mejorTiempo = nivel3?["time"];
      nivel = "nivel3";
    }
  }
}
