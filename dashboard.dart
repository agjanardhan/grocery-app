import 'package:citimark0710/selection/Product.dart';
import 'package:citimark0710/widget.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';

class DashboardPage extends StatefulWidget {
  final List<String> _cartList;
  DashboardPage(this._cartList);
  @override
  _DashboardPageState createState() => _DashboardPageState(this._cartList);
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> _cartList;
  _DashboardPageState(this._cartList);
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchtextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserByUserTown(searchtextEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }
  Widget searchList()
  {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: searchSnapshot.documents[index].data["Name"],
            userPhone: searchSnapshot.documents[index].data["Phone"],
            userTown: searchSnapshot.documents[index].data["Town"],
          );
        }
    ) : Container();
  }

  Widget SearchTile({String userName, String userPhone, String userTown}){
    return  GestureDetector(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(
            builder: (context) => Product(userPhone,_cartList)));
      },
      child: Container(
        margin: EdgeInsets.all(7.0),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical:8),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child:Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                Text(userPhone, style: TextStyle(color:Colors.grey,fontSize: 17,fontWeight:FontWeight.bold,fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mr.Cart'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue.withOpacity(0.2),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical:8),
              decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child:Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: searchtextEditingController,
                          style: singletextstyle(),
                          decoration: InputDecoration(
                              hintText: "your town name",
                              hintStyle: TextStyle(
                                  color: Colors.black26,
                              fontSize: 17,fontStyle: FontStyle.italic),
                              border: InputBorder.none),
                        )
                    ),
                     GestureDetector(
                       onTap: (){
                         initiateSearch();
                       },
                       child: Icon(Icons.search,size: 30,),
                     )
                  ]
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

