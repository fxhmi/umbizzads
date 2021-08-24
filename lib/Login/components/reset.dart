// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umbizz/DialogBox/errorDialog.dart';
import 'package:umbizz/Login/components/background.dart';
import 'package:umbizz/Widgets/rounded_button.dart';


class ResetScreen extends StatefulWidget {

  @override
  _ResetScreenState createState() => _ResetScreenState();

}

class _ResetScreenState extends State<ResetScreen> {

  String email;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
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
      ),
      body: LoginBackground(
        child: Column(
          children: [

            new Image.asset(
              "assets/images/logo.png",
              height: size.height*0.50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email'
                ),
                onChanged: (value) {
                  setState(() {
                    email = value.trim();
                  });
                },
              ),
            ),
            RoundedButton(
              text: "SEND REQUEST",
              press: (){
                _auth.sendPasswordResetEmail(email: email);
                Navigator.of(context).pop();
              },
            ),
          ],),
      ),
    );
  }
}