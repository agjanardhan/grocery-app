import 'package:citimark0710/selection/things.dart';
import 'package:citimark0710/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../conversation_screen.dart';
import '../database.dart';

class Product extends StatefulWidget {
 final String userPhone;
 final List<String> _cartList;
  Product(this.userPhone,this._cartList);
  @override
  _ProductState createState() => _ProductState(this.userPhone,this._cartList);
}

class _ProductState extends State<Product> {
  String userPhone;
  List<String> _cartList;
  _ProductState(this.userPhone, this._cartList);

  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot snapShot;

  List<things1> orderlist = List<things1>();
//List<things1> sortedmsgs = orderist..sort((a,b)=>a.name.compareTo(b.name));
  createChatroomAndStartConversation({String userPhone}) {
    print("${Constants.myPhone}");
    if (userPhone != Constants.myPhone) {
      String chatRoomId = getChatRoomId(userPhone, Constants.myPhone);
      List <String> users = [userPhone, Constants.myPhone];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      main7();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("you cannot send message to yourself");
    }
  }

  IterateCart() {
    for (int i = 0; i <= _cartList.length + 1; i++) {
      main(i);
    }
  }

 main7(){
    for(int i = 0;i<orderlist.length;i++){
      String jay = orderlist[i].name;
      String jay1 = orderlist[i].pricee.toString();
      String jay2 = orderlist[i].counter.toString();
      mainjay(jay,jay1,jay2);
    }
}

void mainjay(jay,jay1,jay2){
    Map<String, dynamic> messageMap = {
      "message": 'Product: $jay ,Price: $jay1 ,quantity: $jay2',
      "sendBy": Constants.myPhone,
      "time": DateTime.now().millisecondsSinceEpoch
    };
    String chatRoomId = getChatRoomId(userPhone, Constants.myPhone);
    databaseMethods.addConversationMessages(chatRoomId, messageMap);
  }
  void main(i) async {
    var AddProduct = await Firestore.instance.collection("shops")
        .document(widget.userPhone)
        .collection("Itemnames")
        .where("Item", isEqualTo: _cartList[i])
        .snapshots();
    AddProduct.forEach((res) {
      res.documents.asMap().forEach((index, data) {
        var list1 = <things1>[
          things1(
            name: res.documents[index]["Item"],
            pricee: res.documents[index]["price"],
            counter: 1,
            pq: res.documents[index]["price"],
          )
        ];
        setState(() {
          orderlist = orderlist + list1;
        });
      });
    });
  }

  int Total = 0;

   main44(){
     for(int i = 0;i < orderlist.length; i++) {
       Total = Total + orderlist[i].pricee;
     }
     Padding(padding:EdgeInsets.all(8.0), child:Container(child:Row(
       children: [
         Text('Total',style:singletextstyle()),
         Text(Total.toString(),style:singletextstyle()),],),),);
  }
  @override
  void initState() {
    super.initState();
    IterateCart();
    super.initState();
  }

 _CartList() {
    return orderlist != null ? ListView.builder(
        itemCount: orderlist.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item1 = orderlist[index];
          return Card(
              margin: EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(item1.name, style: singletextstyle(),),
                      Text(item1.pq.toString(), style: mediumtextstyle1(),),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 9.0, top: 9.0, bottom: 9.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(icon: Icon(
                            Icons.remove_circle, size: 30, color: Colors.blue,),
                              onPressed: () async {
                                if (item1.counter < 2) {
                                  ConfirmAction action = await _asyncConfirmDialog(
                                      context);
                                  if (action != ConfirmAction.Cancel) {
                                    setState(() {
                                      orderlist.remove(item1);
                                      Total = Total - item1.pricee;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    orderlist[index].counter = item1.counter - 1;
                                    orderlist[index].pq = item1.pricee * item1.counter;
                                    Total = Total - item1.pricee;
                                  });
                                }
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        child: Text(item1.counter.toString(), style: singletextstyle()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(icon: Icon(
                            Icons.add_circle, size: 30, color: Colors.blue,),
                              onPressed: () async {
                                setState(() {
                                  orderlist[index].counter = item1.counter + 1;
                                  orderlist[index].pq = item1.pricee * item1.counter;
                                  Total = Total + item1.pricee;
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
          }) : Container(child: Center(child: CircularProgressIndicator()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mr.Cart'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child:
       Stack(
          children: [
            _CartList(),
            GestureDetector(
              onTap: (){
                createChatroomAndStartConversation(userPhone: userPhone);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                  child: Text('Order',style: singletextstyle(),),
                ),
              ),
            ),
          ]
       ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
enum ConfirmAction {Cancel,Accept}
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async{
  return await showDialog<ConfirmAction>(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Remove this item?'),
          content: Text('This will remove the item from your cart.'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: Text('Remove'),
              onPressed: (){
                 Navigator.of(context).pop(ConfirmAction.Accept);
              },
            ),
          ],
        );
      }
  );
}

