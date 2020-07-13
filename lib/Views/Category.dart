import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookbook/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'recipePage.dart';

//import 'package:cached_network_image/cached_network_image.dart';
Category _category;

class CategoryPage extends StatefulWidget {
  CategoryPage({@required this.cat, Key key}) : super(key: key);
  final Category cat;

  _CategoryPageState createState() {
    _category = cat;
    return _CategoryPageState();
  }
}

class _CategoryPageState extends State<CategoryPage> {
  List<Recipe> recipes = new List<Recipe>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/woodbg.jpg"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter)),
            child: ListView(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(0),
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                imageUrl: _category.img, //"http://via.placeholder.com/350x150",
                placeholder: (context, url) => Image.asset("assets/clogo.png"),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),),
                    Container(
                        color: Colors.black54,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            _category.name,
                            style: TextStyle(
                                fontFamily: "lal",
                                fontSize: 30,
                                color: Colors.white),
                            maxLines: 1,
                          ),
                        ))
                  ],
                ),
                Container(
                  color: Colors.white,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Recipes')
                          .where('cat',isEqualTo: _category.name)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator()));
                        } else {
                          return GridView.count(
                              padding: EdgeInsets.all(10),
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: _recipiesGridView(snapshot.data.documents));
                        }
                      }),
                ),
                Container(
              height: 50,
            )
              ],
            )));
  }

  List<Widget> _recipiesGridView(List<DocumentSnapshot> snap) {
    Recipe recipe; // = Recipe.fromSnapshot(snap);
    List<Widget> res = new List<Widget>();
    Widget w;
    for (var item in snap) {
      recipe = Recipe.fromSnapshot(item);
      if (recipe.name.contains("")) {
        recipes.add(recipe);
      }
    }
    for (var rec in recipes) {
      w = new FlatButton(
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => new CategoryPage(name: category)));
          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new RecipePage(
                          recipe: rec,
                          fs:18
                        )));
        },
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.width / 2 - 50,
                width: MediaQuery.of(context).size.width / 2 - 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown, width: 5.0),
                  borderRadius: new BorderRadius.circular(
                      MediaQuery.of(context).size.width / 8),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width / 8 - 5),
                    child: 
                    CachedNetworkImage(
                imageUrl: rec.img, //"http://via.placeholder.com/350x150",
                placeholder: (context, url) => Image.asset("assets/clogo.png"),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
                        )),
            Center(child:Text(
              rec.name,
              style: TextStyle(
                  fontFamily: "lal", fontSize: 18, color: Colors.black),
              maxLines: 1,
            ),)
          ],
        ),
      );
      res.add(w);
    }
    return res;
  }
}
