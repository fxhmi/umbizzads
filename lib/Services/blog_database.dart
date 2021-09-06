// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umbizz/globalVar.dart';

class CrudMethods {

  FirebaseAuth auth;

  Future<void> addData(blogData) async {
    FirebaseFirestore.instance.collection("blogs").add(blogData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("blogs").snapshots();
  }
}