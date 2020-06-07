import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/models/models.dart';
import 'Category.dart';
import 'dart:math';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';

const SCALE_FRACTION = 0.6;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 200.0;

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;
  List<Recipe> recipes = new List<Recipe>();
  double viewPortFraction = 0.5;
  int currentPage = 10;
  String recipeText = "";
  double page = 2.0;

  @override
  initState() {
    super.initState();
    controller = new PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: viewPortFraction,
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
            padding: EdgeInsets.all(0),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.height * 0.25,
            child: Stack(alignment: Alignment.bottomLeft, children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Recipes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()));
                  }
                  builder(snapshot.data.documents.take(5).toList());

                  return new Container(
                    height: PAGER_HEIGHT,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollUpdateNotification) {
                          setState(() {
                            page = controller.page;
                          });
                        }
                        return true;
                      },
                      child: PageView.builder(
                        onPageChanged: (pos) {
                          setState(() {
                            currentPage = pos;
                            recipeText = recipes[pos].name;
                          });
                        },
                        physics: BouncingScrollPhysics(),
                        controller: controller,
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final scale = max(
                              SCALE_FRACTION,
                              (FULL_SCALE - (index - page).abs()) +
                                  viewPortFraction);
                                  
                          return circleOffer(recipes[index].img, scale);
                        },
                      ),
                    ),
                  );
                  // PageView(
                  //   controller: controller,
                  //   children: builder(snapshot.data.documents.take(5).toList()),
                  //   //snapshot.data.documents.length,
                  // );
                },
              )
            ]),
            //,
          ),
          Center(
              child: Text(
            recipeText,
            style:
                TextStyle(fontFamily: "lal", fontSize: 22, color: Colors.white),
            maxLines: 1,
          )),
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

  void builder(List<DocumentSnapshot> snap) {
    Recipe recipe; // = Recipe.fromSnapshot(snap);
    for (var item in snap) {
      recipe = Recipe.fromSnapshot(item);
      if (recipe.name.contains("")) {
        recipes.add(recipe);
      }
    }
  }

  Widget circleOffer(String image, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            height: PAGER_HEIGHT * scale,
            width: PAGER_HEIGHT * scale,
            child: Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(
                    side: BorderSide(color: Colors.grey.shade200, width: 5)),
                child: FadeInImage.assetNetwork(
                    placeholder: "assets/clogo.png",
                    image: image,
                    fit: BoxFit.cover)),
          )),
    );
  }

  List<Widget> _catList(List<DocumentSnapshot> snap) {
    Category category;
    List<Widget> res = new List<Widget>();
    Widget w;
    List<Category> cats = new List<Category>();
    for (var item in snap) {
      category = Category.fromSnapshot(item);
      cats.add(category);
    }

    for (var category in cats) {
      w = new FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new CategoryPage(name: category)));
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
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width),
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
        ),
      );
      res.add(w);
    }
    return res;
  }
}
