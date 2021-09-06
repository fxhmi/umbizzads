// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umbizz/Helperfunctions/sharepref_helper.dart';
import 'package:umbizz/globalVar.dart';

class DatabaseMethods {

  // Future addMessage(
  //     String chatRoomId, String messageId, Map messageInfoMap) async {
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .doc(messageId)
  //       .set(messageInfoMap);
  // }

  //addMessage
  Future addReport(
      String uid, String reportId, Map reportInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reports")
        .doc(reportId)
        .set(reportInfoMap);
  }

  updateLastReportSend(String reportRoomId, Map lastReportInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(reportRoomId)
        .update(lastReportInfoMap);
  }

  createChatRoom(String reportRoomId, Map reportRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("users")
        .doc(reportRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("users")
          .doc(reportRoomId)
          .set(reportRoomInfoMap);
    }
  }


}