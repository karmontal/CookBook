import 'package:cookbook/models/models.dart';
import 'package:flutter/material.dart';
Recipe _recipe;
class RecipePage extends StatefulWidget {
  

  RecipePage({Key key, this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  _RecipePageState createState() {
    _recipe = this.recipe;
    return _RecipePageState();
  }
}

class _RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
        ),
        Container(width: MediaQuery.of(context).size.width, child: Text(_recipe.name)),
        Container(width: MediaQuery.of(context).size.width, child: Text(_recipe.details))
      ]),
    );
  }
}
