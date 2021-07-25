import 'package:flutter/material.dart';
InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color:Colors.black26,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),),
  );
}
TextStyle singletextstyle(){
  return TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic);
}
TextStyle mediumtextstyle(){
  return TextStyle(color:Colors.grey,fontSize: 15,fontWeight:FontWeight.bold,fontStyle: FontStyle.italic);
}
TextStyle mediumtextstyle1(){
  return TextStyle(color:Colors.black54,fontSize: 16,fontWeight:FontWeight.bold,fontStyle: FontStyle.italic);
}