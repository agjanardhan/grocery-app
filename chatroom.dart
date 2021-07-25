import 'package:citimark0710/userlogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/Authentication.dart';
import 'package:citimark0710/database.dart';
import 'package:citimark0710/constants.dart';
import 'package:citimark0710/widget.dart';
import 'package:citimark0710/helperfunctions.dart';
import 'package:citimark0710/conversation_screen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                  snapshot.data.documents[index].data["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myPhone,""),
                 snapshot.data.documents[index].data["chatroomId"]
              );

            }) : Container();
      },
    );
  }


  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myPhone = await HelperFunctions.getUserPhoneSharedPreference();
    databaseMethods.getChatRoom(Constants.myPhone).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mr.cart'),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
               AuthService().signOut();
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) => LoginPage()));
               },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app))
          )
        ],
      ),
      body:
           chatRoomList(),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userPhone;
  final String chatRoomId;
  ChatRoomTile(this.userPhone,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 4.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
            color: Colors.white),
        child: Row(
            children: [
              Container(
                height: 60,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Text("${userPhone.substring(0,1).toUpperCase()}", style: singletextstyle()),
              ),
              SizedBox(width:12,),
              Text(userPhone, style:singletextstyle(),)
            ]
        ),
      ),
    );
  }


}