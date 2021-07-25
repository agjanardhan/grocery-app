import 'package:citimark0710/navigationbar.dart';
import 'package:citimark0710/selection/listboard.dart';
import 'package:citimark0710/userlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';

class  AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return  MyBottomBar();
        }
        else {
          return LoginPage();
        }
      }
    );
  }
  signOut(){
    FirebaseAuth.instance.signOut();
  }
}