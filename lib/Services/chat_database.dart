// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umbizz/Helperfunctions/sharepref_helper.dart';
import 'package:umbizz/globalVar.dart';

class DatabaseMethods {

  //guna untuk save user data when sign in
  Future addUserInfoToDB(
      String uid, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userInfoMap);
  }

  //think of something better to search
  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("nameChatId", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future <Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    //String myUsername = getUserName;
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future <QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("nameChatId", isEqualTo: username)
        .get();
  }
}