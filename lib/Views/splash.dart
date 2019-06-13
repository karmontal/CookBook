import 'dart:async';
import 'package:cookbook/Views/mainPage.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  _SplashPageState createState() =>_SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _visible = false;

  _SplashPageState() {
    new Timer(const Duration(seconds: 6), () {
      setState(() {
        _visible = !_visible;
      });
    });
    new Timer(const Duration(milliseconds: 500,seconds: 6),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => new MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: _visible? 0.0:1.0,
            curve: Curves.easeInOutBack,
            child: Center(
                child: Image.asset("assets/clogo.png",
                    width: MediaQuery.of(context).size.width * 0.5)),
          ),
        ],
      ),
    );
    
  }
}
