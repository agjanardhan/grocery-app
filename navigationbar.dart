import 'package:citimark0710/chatroom.dart';
import 'package:citimark0710/selection/listboard.dart';
import 'package:citimark0710/widget.dart';
import 'package:flutter/material.dart';

class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => new _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [ChatRoom(),ListBoard()];

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: BottomNavigationBar(
         currentIndex: _pageIndex,
           onTap: onTabTapped,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem( icon: Icon(Icons.mail), title: Text("Messages")),
             BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          ],

      ),
       body: PageView(
      children: tabPages,
      onPageChanged: onPageChanged,
      controller: _pageController,
    ),
    );
  }
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}