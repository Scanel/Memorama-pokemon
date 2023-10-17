import 'package:flutter/material.dart';
import 'package:miniproyecto_02/src/splash_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memorama Pokemon"),
        backgroundColor: Colors.red,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Nivel 1",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SplashScreen(total: 8)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue, onPrimary: Colors.white),
            ),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Nivel 2",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SplashScreen(total: 10)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber, onPrimary: Colors.white),
            ),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Nivel 3",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SplashScreen(total: 12)));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.red, onPrimary: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
