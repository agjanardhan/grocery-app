import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods{
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getUserByUsername(String username) async{
    return await Firestore.instance.collection("users")
        .where("name",isEqualTo: username)
        .getDocuments();
  }
  getUserByUserTown(String userTown) async{
    return await Firestore.instance.collection("shops")
        .where("Town",isEqualTo: userTown)
        .getDocuments();
  }
  getUserByUserPhone(String userPhone) async{
    return await Firestore.instance.collection("users")
        .where("Phone",isEqualTo: userPhone)
        .getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }
  getConversationMessages(String chatRoomId) async{
     return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  getProducts() async{
    return await Firestore.instance.collection('products').getDocuments();
  }
  getChatRoom(String userPhone) async{
    return await Firestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userPhone)
        .snapshots();
  }
}
