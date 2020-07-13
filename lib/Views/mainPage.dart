import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookbook/Views/recipePage.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/models/models.dart';
import 'dart:math';

import 'Category.dart';
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
  int currentPage = 5;
  String recipeText = "";
  double page = 2.0;
  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  initState() {
    super.initState();
    controller = new PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: viewPortFraction,
    );
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-2738619858586311~9330585255")
        .whenComplete(() => myBanner
          ..load()
          ..show());
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
                stream: Firestore.instance
                    .collection('Recipes')
                    .orderBy("add_date", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()));
                  }
                  if (recipes.length == 0) {
                    var snap = snapshot.data.documents.take(5).toList();
                    for (var item in snap) {
                      final Recipe recipe = Recipe.fromSnapshot(item);
                      recipes.add(recipe);
                    }
                  }

                  print("LLLLLLLLLLLLLLLLLLLL" + recipes.length.toString());
                  //recipeText = recipes[currentPage].name;
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
                            //currentPage = pos;
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

                          return circleOffer(recipes[index], scale);
                        },
                      ),
                    ),
                  );
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
              stream: Firestore.instance.collection('Categories').orderBy("orderID").snapshots(),
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
                  children: _catList(snapshot.data.documents),
                );
              },
            ),
          ),
          Container(
            height: 50,
          )
        ],
      ),
    ));
  }

  Widget circleOffer(Recipe rec, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
          onTap: () {
            print(rec.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new RecipePage(
                          recipe: rec,
                          fs:18
                        )));
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            height: PAGER_HEIGHT * scale,
            width: PAGER_HEIGHT * scale,
            child: Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: CircleBorder(
                  side: BorderSide(color: Colors.grey.shade200, width: 5)),
              child: CachedNetworkImage(
                imageUrl: rec.img, //"http://via.placeholder.com/350x150",
                placeholder: (context, url) => Image.asset("assets/clogo.png"),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              // FadeInImage.assetNetwork(
              //     placeholder: "assets/clogo.png",
              //     image: image,
              //     fit: BoxFit.cover)
            ),
          )),
    );
  }

  List<Widget> _catList(List<DocumentSnapshot> snap) {
    
    List<Widget> res = new List<Widget>();
    Widget w;
    List<Category> cats = new List<Category>();
    for (var item in snap) {
      final Category category = Category.fromSnapshot(item);
      cats.add(category);
    }

    for (var category in cats) {
      w = new FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => new CategoryPage(cat:category),
            ));
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
                    child: CachedNetworkImage(
                      imageUrl:
                          category.img, //"http://via.placeholder.com/350x150",
                      placeholder: (context, url) =>
                          Image.asset("assets/clogo.png"),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    // FadeInImage.assetNetwork(
                    //     placeholder: "assets/clogo.png",
                    //     image: category.img,
                    //     fit: BoxFit.cover)
                  )),
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
