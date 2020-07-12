import 'package:cookbook/Views/recipePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/models/models.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;
  int currentpage = 0;

  @override
  initState() {
    super.initState();
    controller = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 0.6,
    );
  }

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
          Container(
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.height * 0.25,
            child: Stack(alignment: Alignment.bottomLeft, children: <Widget>[
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3.0),
                    borderRadius: new BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                  )),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Recipes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()));
                  //print(snapshot.data.documents[0].documentID);
                  return new PageView(
                    controller: controller,
                    children: builder(snapshot.data.documents.take(5).toList()),
                    //snapshot.data.documents.length,
                  );
                },
              )
            ]),
            //,
          ),
          Image(
            height: MediaQuery.of(context).size.height * 0.02,
            fit: BoxFit.cover,
            image: AssetImage("assets/top.png"),
          ),
          Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "التصنيفات",
                  style: TextStyle(
                      fontFamily: "lal", fontSize: 30, color: Colors.black),
                  maxLines: 1,
                ),
              )),
          Container(
            //height: MediaQuery.of(context).size.height * 0.73 - 28,
            color: Colors.white,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Categories').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()));
                return GridView.count(
                    padding: EdgeInsets.all(10),
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: _catList(snapshot.data.documents));
              },
            ),
          ),
        ],
      ),
    ));
  }

  List<Widget> builder(List<DocumentSnapshot> snap) {
    //final Recipe recipe; // = Recipe.fromSnapshot(snap);
    List<Widget> res = new List<Widget>();
    Widget w;
    for (var item in snap) {
      final Recipe recipe = Recipe.fromSnapshot(item);
      if (recipe.name.contains("")) {
        w = new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  String _n =recipe.name;
                  Navigator.push(context, MaterialPageRoute(builder:(context) => new RecipePage(recipe: recipe,)));
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5.0),
                      borderRadius: new BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.09),
                      // image: DecorationImage(
                      //     image: NetworkImage(recipe.img),
                      //     fit: BoxFit.cover,
                      //     alignment: Alignment.center)
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.1),
                        child: FadeInImage.assetNetwork(
                            placeholder: "assets/wlogo.png",
                            image: recipe.img,
                            fit: BoxFit.cover)))),
            Text(
              recipe.name,
              style: TextStyle(
                  fontFamily: "lal", fontSize: 22, color: Colors.white),
              maxLines: 1,
            ),
          ],
        );
        res.add(w);
      }
    }
    return res;
  }

  List<Widget> _catList(List<DocumentSnapshot> snap) {
    Category category;
    List<Widget> res = new List<Widget>();
    Widget w;
    for (var item in snap) {
      category = Category.fromSnapshot(item);
      w = new FlatButton(
          onPressed: () {
            return 0;
          },
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.width / 2 - 50,
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown, width: 5.0),
                    borderRadius: new BorderRadius.circular(
                        MediaQuery.of(context).size.width / 4 - 25),
                    // image: DecorationImage(
                    //     image: NetworkImage(category.img),
                    //     fit: BoxFit.cover,
                    //     alignment: Alignment.center)
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 4 - 25),
                      child: FadeInImage.assetNetwork(
                          placeholder: "assets/clogo.png",
                          image: category.img,
                          fit: BoxFit.cover))),
              Text(
                category.name,
                style: TextStyle(
                    fontFamily: "lal", fontSize: 22, color: Colors.black),
                maxLines: 1,
              ),
            ],
          ));
      res.add(w);
    }
    return res;
  }
}
