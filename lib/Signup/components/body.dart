// @dart=2.9
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:umbizz/DialogBox/errorDialog.dart';
import 'package:umbizz/DialogBox/loadingDialog.dart';
import 'package:umbizz/Login/login_screen.dart';
import 'package:umbizz/Signup/components/background.dart';
import 'package:umbizz/Welcome/welcome_screen.dart';
import 'package:umbizz/Widgets/already_have_an_account_acheck.dart';
import 'package:umbizz/Widgets/rounded_button.dart';
import 'package:umbizz/Widgets/rounded_input_field.dart';
import 'package:umbizz/Widgets/rounded_password.dart';
import 'package:umbizz/Widgets/rounded_password_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:umbizz/globalVar.dart';

import '../../HomeScreen.dart';

class SignupBody extends StatefulWidget {


  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {

  String userPhotoUrl = "";

  File _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
  }

  //after user upload the information
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
          _register();
        });
  }

    //save email pwd
    void _register() async{

      User currentUser;

      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      ).then((auth){

        currentUser = auth.user;
        userId = currentUser.uid;
        userEmail = currentUser.email;
        getUserName = _nameController.text.trim();
        //getUserName = currentUser.displayName;
        //currentUser.updateDisplayName(getUserName);

        saveUserData();

      }).catchError((error){
        Navigator.pop(context);
        showDialog(context: context, builder: (con) {
          return ErrorAlertDialog(
          message: error.message.toString(),
          );
        });
      });

      //kalau user dah login gi home screen
      if (currentUser != null){
        Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      }

    }

    //save user data
    void saveUserData(){
    Map<String, dynamic> userData = {
      'userName' : _nameController.text.trim(),
      'uid' : userId,
      'userNumber' : _phoneController.text.trim(),
      'imgPro': userPhotoUrl,
      'time': DateTime.now(),
      'status': "approved",
      'about': "Update your about",
      'businessName': "",
      'email': userEmail,
      'nameChatId': userEmail.replaceAll("@siswa.um.edu.my", ""),
      'spend': "0",
      'income': "0",
      'report': ""
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
    //take user id to get all other data
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
    _screenHeight = MediaQuery.of(context).size.width;

    int defaultEmailLength = "wie180024@siswa.um.edu.my".length;
    String defaultDomain = "@siswa.um.edu.my";

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(145, 131, 222, 1),
          Color.fromRGBO(160, 148, 227, 1),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: SignupBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              InkWell(
                onTap: () {
                  chooseImage();
                },
                child: CircleAvatar(
                  radius: _screenWidth * 0.20,
                  backgroundColor: Colors.deepPurple[100],
                  backgroundImage: _image==null ? null : FileImage(_image),
                  child: _image == null
                  ? Icon(
                    //else show icon
                    Icons.add_photo_alternate,
                    size: _screenWidth* 0.20,
                    color: Colors.white,
                )
                      :null,
                )
              ),


              SizedBox(height: _screenHeight*0.01),
              RoundedInputField(
                hintText: "Display Name",
                icon: Icons.person,
                onChanged: (value)
                  {
                    _nameController.text = value;
                  },
              ),
              RoundedInputField(
                hintText: "Siswamail",
                icon: Icons.alternate_email_rounded ,
                onChanged: (value)
                {
                  _emailController.text = value;
                },
              ),
              RoundedInputField(
                hintText: "Phone No. Exp: 012 XXX XXXX",
                icon: Icons.add_ic_call,
                onChanged: (value)
                {
                  _phoneController.text = value;
                },
              ),
              RoundedPasswordField(
                onChanged: (value)
                {
                  _passwordController.text = value;
                },
              ),

              RoundedButton(
                text: "SIGN UP",
                press: ()
                {
                  if(_nameController.text == "" && _emailController.text == "" && _phoneController.text == "" && _passwordController.text == "" && _image == null) {
                    showToast(
                      "Please Insert Valid Credentials to Proceed",
                      duration: 3,
                      gravity: Toast.BOTTOM,
                    );
                    } else if (_emailController.text.length != defaultEmailLength && _emailController.text.substring(9,_emailController.text.length) != defaultDomain ){
                    showToast(
                      "Please use non-existing Siswamail account to proceed",
                      duration: 3,
                      gravity: Toast.BOTTOM,
                    );
                    } else {
                    upload();
                  }
                },
              ),
              SizedBox(height: _screenHeight * 0.03,),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)
                        {
                         return LoginScreen();
                        },
                    ),
                  );
                },
              )
            ],

          ),
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}){
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
