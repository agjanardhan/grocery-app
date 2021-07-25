import 'dart:async';
import 'package:citimark0710/selection/things.dart';
import 'package:citimark0710/widget.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/constants.dart';
import 'package:citimark0710/database.dart';

class ConversationScreen extends StatefulWidget {
  final  String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream chatMessagesStream;
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == Constants.myPhone);
            }) : Container();
      },
    );
  }
ScrollController _controller = ScrollController();
  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myPhone,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text ="";

     // Timer(Duration(milliseconds: 500),() => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white10.withOpacity(0.4),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller:messageController,
                            style: TextStyle(color:Colors.black),
                            decoration: InputDecoration(
                                hintText: "Type....",
                                hintStyle: mediumtextstyle1(),
                              border: InputBorder.none),
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessages();
                          _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                        },
                        child: Icon(Icons.near_me,size: 30)
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only( left: isSendByMe ? 30 : 24, right: isSendByMe ? 24 : 30 ),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xFF207EFA),
                const Color(0xFF2A75BC)
              ] : [
                const Color(0xFF2A75BC),
                const Color(0xFF2A75BC)
              ],
            ),
            borderRadius: isSendByMe ?
            BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white,
            fontSize: 17
        ),),
      ),
    );
  }
}
