// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umbizz/DialogBox/errorDialog.dart';
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
      appBar: AppBar(title: Text('Reset Password'),),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.05,),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height*0.30,
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
    );
  }
}