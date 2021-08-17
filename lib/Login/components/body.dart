// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umbizz/DialogBox/errorDialog.dart';
import 'package:umbizz/DialogBox/loadingDialog.dart';
import 'package:umbizz/HomeScreen.dart';
import 'package:umbizz/Login/components/background.dart';
import 'package:umbizz/Login/components/reset.dart';
import 'package:umbizz/Signup/signup_screen.dart';
import 'package:umbizz/Widgets/already_have_an_account_acheck.dart';
import 'package:umbizz/Widgets/rounded_button.dart';
import 'package:umbizz/Widgets/rounded_input_field.dart';
import 'package:umbizz/Widgets/rounded_password.dart';
import 'package:umbizz/Widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_screen.dart';

class LoginBody extends StatefulWidget {

  @override
  _LoginBodyState createState() => _LoginBodyState();

}

class _LoginBodyState extends State<LoginBody> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async{
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog();
        });

    User currentUser;

    await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (con) {
        return ErrorAlertDialog(
          message: error.message.toString(),
        );
      });
    });

    if(currentUser!=null){
      getUserData(currentUser.uid);
    }
    else{
      print("error");
    }
  }

  getUserData(String uid) async {

    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((
        results) {

      String status = results.data()['status'];

      if (status == "approved") {

        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);

      } else {

        _auth.signOut();

        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (context) => LoginScreen());
        Navigator.pushReplacement(context, newRoute);

        showDialog(
            context: context,
            builder: (con) {
              return ErrorAlertDialog(
                message: "You are blocked by the Admin. Please contact our helpline",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05,),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height*0.45,
            ),
            SizedBox(height: size.height * 0.005,),
            RoundedInputField(

              hintText: "Siswamail",
              icon: Icons.person,
              onChanged: (value)
              {
                _emailController.text = value;
              },
            ),

            RoundedPasswordField(
              onChanged: (value)
              {
                _passwordController.text = value;
              },
            ),


            RoundedButton(
              text: "LOGIN",
              press: (){
                _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                    ? _login()
                    : showDialog(
                    context: context,
                    builder: (con){
                      return ErrorAlertDialog(
                        message: 'Please provide your credentials for Login',
                      );
                    });

              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text("Forgot Password"),
                    onPressed: ()
                    => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetScreen()))
                ),
              ],
            ),

            SizedBox(height: size.height * 0.0008,),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)
                    {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
    ),
    );
  }
}
