import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookbook/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Recipe _recipe;
double _fontSize = 18;

class RecipePage extends StatefulWidget {
  RecipePage({Key key, this.recipe, this.fs}) : super(key: key);
  final Recipe recipe;
  final double fs;

  @override
  _RecipePageState createState() {
    _recipe = this.recipe;
    _fontSize = fs;
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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown,
            actions: [
              Container(
                  width: 60,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  )),
              Container(
                  width: 60,
                  child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, a1, a2) => RecipePage(
                                  recipe: _recipe,
                                  fs: _fontSize + 1,
                                )),
                      );
                    },
                    child: Text(
                      "A+",
                      style: TextStyle(fontSize: 20),
                    ),
                    shape: CircleBorder(),
                  )),
              Container(
                  width: 60,
                  child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, a1, a2) => RecipePage(
                                  recipe: _recipe,
                                  fs: _fontSize - 1,
                                )),
                      );
                    },
                    child: Text(
                      "A-",
                      style: TextStyle(fontSize: 16),
                    ),
                    shape: CircleBorder(),
                  )),
            ],
          ),
          body: ListView(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: CachedNetworkImage(
                        imageUrl: _recipe.img,
                        placeholder: (context, url) =>
                            Image.asset("assets/clogo.png"),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        height: 50,
                        color: Colors.black54,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            _recipe.name,
                            style: TextStyle(
                                fontFamily: "lal",
                                fontSize: 30,
                                color: Colors.white),
                            maxLines: 1,
                          ),
                        ))
                  ],
                )),
            Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                color: Colors.brown[200],
                child: Text(
                  "المقادير",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _fontSize + 8,
                      fontWeight: FontWeight.w400,
                      fontFamily: "lal"),
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: AlignmentDirectional.topStart,
                    repeat: ImageRepeat.repeat,
                    scale: 2.5,
                    image: AssetImage("assets/recipeBG.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                child: HtmlWidget(_recipe.ings,
                    textStyle:
                        TextStyle(fontFamily: "lal", fontSize: _fontSize))),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 15,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.brown[700])]),
            ),
            Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                color: Colors.brown[200],
                child: Text(
                  "طريقة التحضير",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _fontSize + 8,
                      fontWeight: FontWeight.w400,
                      fontFamily: "lal"),
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: AlignmentDirectional.topStart,
                    repeat: ImageRepeat.repeat,
                    scale: 2.5,
                    image: AssetImage("assets/recipeBG.png"),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                child: HtmlWidget(_recipe.details,
                    textStyle:
                        TextStyle(fontFamily: "lal", fontSize: _fontSize))),
            Container(
              height: 50,
            )
          ]),
        ));
  }
}
