import 'package:flutter/material.dart';
import 'package:miniproyecto_02/src/memorama_game.dart';

class SplashScreen extends StatefulWidget {
  int total;
  SplashScreen({required this.total});

  @override
  _SplashScreenState createState() => _SplashScreenState(total: total);
}

class _SplashScreenState extends State<SplashScreen> {
  int total;
  _SplashScreenState({required this.total});
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: 5000),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MemoramaGame(total: total))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                image: NetworkImage(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")),
            SizedBox(height: 50),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
