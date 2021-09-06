// // @dart=2.9
// import 'dart:io';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:umbizz/DialogBox/errorDialog.dart';
// import 'package:umbizz/DialogBox/loadingDialog.dart';
// import 'package:umbizz/HomeScreen.dart';
// import 'package:umbizz/Widgets/appbar_widget.dart';
// import 'package:umbizz/Widgets/form_widget.dart';
// import 'package:umbizz/Widgets/profile_widget.dart';
// import 'package:umbizz/globalVar.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
// import 'package:umbizz/globalVar.dart';
//
// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String userName;
//   String userNumber;
//   String about;
//   String businessName;
//   QuerySnapshot users;
//
//   File _image;
//   final picker = ImagePicker();
//   String userPhotoUrl = "";
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   chooseImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     File file = File(pickedFile.path);
//
//     setState(() {
//       _image = file;
//     });
//   }
//
//   upload() async{
//     showDialog(
//         context: context,
//         builder: (_) {
//           return LoadingAlertDialog();
//         });
//
//     String fileName = DateTime
//         .now()
//         .millisecondsSinceEpoch.toString();
//
//     //save the file and image to firebase
//     firebaseStorage.Reference reference =
//     firebaseStorage.FirebaseStorage.instance.ref().child(fileName);
//     firebaseStorage.UploadTask uploadTask = reference.putFile(_image);
//     firebaseStorage.TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {
//
//     });
//
//     await storageTaskSnapshot.ref.getDownloadURL().then((url){
//       userPhotoUrl = url;
//       print(userPhotoUrl);
//       //_update();
//     });
//   }
//
//   // //save email pwd
//   // void _update() async{
//   //
//   //   User currentUser;
//   //
//   //   await _auth.createUserWithEmailAndPassword(
//   //       email: _emailController.text.trim(),
//   //       password: _passwordController.text.trim()
//   //   ).then((auth){
//   //
//   //     currentUser = auth.user;
//   //
//   //     userId = currentUser.uid;
//   //     userEmail = currentUser.email;
//   //     getUserName = _nameController.text.trim();
//   //
//   //
//   //     saveUserData();
//   //
//   //   }).catchError((error){
//   //     Navigator.pop(context);
//   //     showDialog(context: context, builder: (con) {
//   //       return ErrorAlertDialog(
//   //         message: error.message.toString(),
//   //       );
//   //     });
//   //   });
//
//   //   //kalau user dah login gi home screen
//   //   if (currentUser != null){
//   //     Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
//   //     Navigator.pushReplacement(context, newRoute);
//   //   }
//   // }
//
//   // void saveUserData(){
//   //   Map<String, dynamic> userData = {
//   //     'userName' : _nameController.text.trim(),
//   //     'uid' : userId,
//   //     'userNumber' : _phoneController.text.trim(),
//   //     'imgPro': userPhotoUrl,
//   //     'time': DateTime.now(),
//   //     'status': "approved",
//   //     'about': "Update your about"
//   //   };
//   //
//   //   FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
//   //
//   //   //take user id to get all other data
//   // }
//
//   Future <bool> showDialogForUpdateData(selectedUserId) async{
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context){
//           return SingleChildScrollView(
//             child: AlertDialog(
//               title: Text("Update Data", style: TextStyle(fontSize: 24, fontFamily: 'Bebas', letterSpacing: 2.0),),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: getUserName,
//                     ),
//                     onChanged: (value){
//                       setState(() {
//                         this.userName = value;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 5.0,),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: getUserNum,
//                     ),
//                     onChanged: (value){
//                       setState(() {
//                         this.userNumber = value;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 5.0,),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Update your business name',
//                     ),
//                     onChanged: (value){
//                       setState(() {
//                         this.businessName = value;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 5.0,),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: getAbout,
//                     ),
//                     onChanged: (value){
//                       setState(() {
//                         this.about = value;
//                       });
//                     },
//                   ),
//
//                   SizedBox(height: 5.0,),
//
//                 ],
//               ),
//
//               //cancel button
//               actions: [
//                 ElevatedButton(
//                   onPressed: ()
//                   {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                       "Cancel"
//                   ),
//                 ),
//                 ElevatedButton(
//                   child: Text(
//                       "Update Now"
//                   ),
//                   onPressed: (){
//                     Navigator.pop(context);
//
//                     //update database
//                     Map<String, dynamic> itemData = {
//                       'userName': this.userName,
//                       'userNumber': this.userNumber,
//                       'businessName': this.businessName,
//                       'about' : this.about,
//
//                     };
//
//                     FirebaseFirestore.instance.collection('users').doc(selectedUserId).update(itemData).then((value){
//                       print("Data updated successfully.");
//                     }).catchError((onError){
//                       print(onError);
//                     });
//                   },
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) =>  Scaffold(
//
//     appBar: AppBar(
//           title: Text('Edit Profile'),
//           centerTitle: true,
//             leading: const BackButton(),
//       elevation: 0,
//         ),
//
//         //showDialogForUpdateData(getUserId);
//         body: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 32),
//           physics: BouncingScrollPhysics(),
//           children: [
//
//             const SizedBox(height: 15),
//             InkWell(
//               child: ProfileWidget(
//                 imagePath: userPhotoUrl,
//                 isEdit: true,
//                 onClicked: () async {
//                   chooseImage();
//                 },
//               ),
//
//             ),
//
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Seller status",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//                   ),
//                 Transform.scale(
//                   scale: 0.7,
//                   child: CupertinoSwitch(
//                     value: true,
//                     onChanged: (bool val){},
//                   ))
//               ],
//             ),
//
//             const SizedBox(height: 15),
//             TextFieldWidget(
//               label: 'Display Name',
//               text: getUserName,
//               onChanged: (value) {
//                 setState(() {
//                   this.userName = value;
//                 });
//               },
//             ),
//
//
//             const SizedBox(height: 15),
//             TextFieldWidget(
//               label: 'Phone Number',
//               text: getUserNum,
//               onChanged: (value) {
//                 setState(() {
//                   this.userNumber = value;
//                 });
//               },
//             ),
//
//             const SizedBox(height: 15),
//             TextFieldWidget(
//               label: 'Business Name',
//               text: userEmail,
//               onChanged: (value) {
//                 setState(() {
//                   this.businessName = value;
//                 });
//               },
//             ),
//
//             const SizedBox(height: 15),
//             TextFieldWidget(
//               label: 'About',
//               text: getAbout,
//               maxLines: 5,
//               onChanged: (value) {
//                 setState(() {
//                   this.about = value;
//                 });
//               },
//             ),
//
//             ElevatedButton(
//               onPressed: ()
//               {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                   "Cancel"
//               ),
//             ),
//             ElevatedButton(
//               child: Text(
//                   "Update Now"
//               ),
//               onPressed: (){
//                 Navigator.pop(context);
//
//                 //update database
//                 Map<String, dynamic> itemData = {
//                   'userName': this.userName,
//                   'userNumber': this.userNumber,
//                   'businessName': this.businessName,
//                   'about' : this.about,
//                 };
//
//                 FirebaseFirestore.instance.collection('users').doc().update(itemData).then((value){
//                   print("Data updated successfully.");
//                 }).catchError((onError){
//                   print(onError);
//                 });
//               },
//             ),
//           ],
//         ),
//       );
// }