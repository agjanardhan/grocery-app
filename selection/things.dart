import 'package:flutter/cupertino.dart';

import '../constants.dart';
import '../database.dart';

class things{
  final String name;
  final String image;
  things({this.name,this.image});
}
class things1{
  String name;
  int pricee;
  int counter;
  int pq;
  things1({this.name, this.pricee, this.counter, this.pq});

  @override
   String toString(){
    return "$name, $pricee, $counter";
  }
}


