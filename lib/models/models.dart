import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
 final String name;
 final String img;
 final DocumentReference reference;

 Recipe.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       assert(map['img'] != null),
       name = map['name'],
       img = map['img'];

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