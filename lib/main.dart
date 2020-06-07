import 'package:admob_flutter/admob_flutter.dart';
import 'package:cookbook/Views/splash.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  Admob.initialize("ca-app-pub-2738619858586311~5887938469");
  runApp(MaterialApp(
    title: "Cook Book",
    theme: ThemeData(primarySwatch: Colors.red),
    home: SplashPage(),
  ));
}
