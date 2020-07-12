import 'package:cookbook/Views/splash.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  runApp(MaterialApp(
    title: "Cook Book",
    theme: ThemeData(primarySwatch: Colors.red),
    home: SplashPage(),
  ));
}
