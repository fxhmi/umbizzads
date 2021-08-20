// @dart=2.9
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umbizz/DialogBox/loadingDialog.dart';
import 'package:umbizz/HomeScreen.dart';
import 'package:umbizz/Widgets/appbar_widget.dart';
import 'package:umbizz/Widgets/numbers_widget.dart';
import 'package:umbizz/Widgets/profile_button.dart';
import 'package:umbizz/Widgets/profile_widget.dart';
import 'package:umbizz/edit_profile_page.dart';
import 'package:umbizz/globalVar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  String oldName;
  String oldNum;
  String oldAbout;
  QuerySnapshot users;
  bool newPhoto = false;

  File _image;
  final picker = ImagePicker();
  String userPhotoUrl = "";



  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
    newPhoto = true;
  }

  void _uploadPhoto() async {

    savePhoto();

    Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
    Navigator.pushReplacement(context, newRoute);
    newPhoto = false;

  }

  void savePhoto(){
    Map<String, dynamic> userData = {
      'imgPro': userPhotoUrl,
    };

    FirebaseFirestore.instance.collection('users').doc(userId).update(userData).then((value){
      print("Data updated successfully with profile page @savePhoto()");
    }).catchError((onError){
      print(onError);
    });

  }

  upload() async{
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog();
        });

    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch.toString();

    //save the file and image to firebase
    firebaseStorage.Reference reference =
    firebaseStorage.FirebaseStorage.instance.ref().child(fileName);
    firebaseStorage.UploadTask uploadTask = reference.putFile(_image);
    firebaseStorage.TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {

    });

    await storageTaskSnapshot.ref.getDownloadURL().then((url){
      userPhotoUrl = url;
      print(userPhotoUrl);
      _uploadPhoto();

      // if(url.isEmpty)
      //   {
      //     userPhotoUrl = getUserImageUrl;
      //   }else{
      //   print(userPhotoUrl);
      // }
    });
  }

  Future <bool> showDialogForUpdateData(selectedUserId, oldName, oldNum, oldAbout, oldImgPro, width) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text("Update Profile", style: TextStyle(fontSize: 24, fontFamily: 'Bebas', letterSpacing: 2.0),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  const SizedBox(height: 15),
                  InkWell(
                      onTap: () {
                        chooseImage();
                      },
                      child: CircleAvatar(

                        radius: width * 0.20,
                        backgroundColor: Colors.deepPurple[100],
                        backgroundImage: _image == null ? null : FileImage(_image),
                        child: _image == null

                            ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              getUserImageUrl,
                          ),

                          radius: width * 0.20,
                          backgroundColor: Colors.deepPurple[100],
                          //else show icon
                          // Icons.add_photo_alternate,
                          // size: width * 0.20,
                          // color: Colors.white,

                        )
                            :null,
                      ),

                  ),
                  SizedBox(height: 15.0,),

                  TextFormField(
                    decoration: InputDecoration(
                      hintText: getUserName ?? '',
                    ),
                    onChanged: (value){
                      setState(() {
                        oldName = value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: getUserNum ?? '',
                    ),
                    onChanged: (value){
                      setState(() {
                        oldNum = value;
                      });
                    },
                  ),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: getAbout ?? '',
                    ),
                    onChanged: (value){
                      setState(() {
                        oldAbout = value;
                      });
                    },
                  ),

                  SizedBox(height: 5.0,),

                ],
              ),

              //cancel button
              actions: [
                ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  child: Text(
                      "Cancel"
                  ),
                ),
                ElevatedButton(
                  child: Text(
                      "Update Now"
                  ),
                  onPressed: (){

                    Navigator.pop(context);


                    if (newPhoto){

                      upload();

                      //update database with imgPro
                      Map<String, dynamic> userData = {
                        'userName': oldName,
                        'userNumber': oldNum,
                        'about' : oldAbout,
                      };

                      FirebaseFirestore.instance.collection('users').doc(selectedUserId).update(userData).then((value){
                        print("Data updated successfully with profile page");
                      }).catchError((onError){
                        print(onError);
                      });

                    } else {

                      //update database
                      Map<String, dynamic> userData = {
                        'userName': oldName,
                        'userNumber': oldNum,
                        'about' : oldAbout,
                      };

                      FirebaseFirestore.instance.collection('users').doc(selectedUserId).update(userData).then((value){
                        print("Data updated successfully.");
                      }).catchError((onError){
                        print(onError);
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.width;

    return  Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.deepPurple[300],
                Colors.blue,

                // Colors.lightBlueAccent,
                // Colors.blueAccent,

                // Colors.blueGrey,
                // Colors.grey,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
            ),
          ),
        ),
        leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
        ),
        elevation: 0,
      ),

            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [

                const SizedBox(height: 24),
                ProfileWidget(
                  imagePath: getUserImageUrl,
                  onClicked: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()),
                    showDialogForUpdateData(
                        auth.currentUser.uid,
                        getUserName,
                        getUserNum,
                        getAbout,
                        getUserImageUrl,
                        _screenWidth,
                    );

                  },
                ),

                const SizedBox(height: 24),
                buildName(),

                const SizedBox(height: 24),
                Center(child: buildUpgradeButton()),

                const SizedBox(height: 24),
                NumbersWidget(),

                const SizedBox(height: 48),
                buildAbout(),
              ],
            ),
          );
  }

  Widget buildName() => Column(
    children: [
      Text(
        getUserName ?? '',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        userEmail ?? '',
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Verified ✅',
    onClicked: () {},
  );

  Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          getAbout ?? '',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

}