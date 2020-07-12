import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String name;
  String img;
  String details;
  DocumentReference reference;

 Recipe(name,img,details){
    this.name = name;
    this.img = img;
    this.details = details;
 }

 Recipe.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['img'] != null),
       assert(map['details'] != null),
       name = map['name'],
       img = map['img'],
       details = map['details'];

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