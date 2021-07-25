import 'package:citimark0710/Authentication.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'citi Mark',
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}