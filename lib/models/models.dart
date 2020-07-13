import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String name;
  String img;
  String details;
  String ings;
  Timestamp addDate;
  DocumentReference reference;

 Recipe(name,img,ings,details,addDate){
    this.name = name;
    this.img = img;
    this.ings = ings;
    this.details = details;
    this.addDate = addDate;
 }

 Recipe.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['img'] != null),
       assert(map['ings'] != null),
       assert(map['details'] != null),
       assert(map['add_date'] != null),
       name = map['name'],
       img = map['img'],
       ings = map['ings'],
       details = map['details'],
       addDate = map['add_date'];

 Recipe.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Recipe<$name:$img>";
}

class Category {
 final String name;
 final String img;
 final DocumentReference reference;

 Category.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['img'] != null),
       name = map['name'],
       img = map['img'];

 Category.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Category<$name:$img>";
}