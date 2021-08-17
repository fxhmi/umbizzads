// @dart=2.9
import 'package:flutter/material.dart';
import 'package:umbizz/Widgets/text_field_container.dart';


class RoundedPassword extends StatefulWidget {

  RoundedPassword({Key key, this.onChanged}) : super(key: key);

  final ValueChanged<String> onChanged;



  @override
  _RoundedPasswordState createState() =>  _RoundedPasswordState();
}

class _RoundedPasswordState extends State<RoundedPassword> {

  

  // Initially password is obscure
  bool _obscureText = true;
  

  

  // Toggles the password show status
  void initState() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    var onChanged;
    return TextFieldContainer(
      child: TextField(
        obscureText: !_obscureText,
        onChanged: onChanged,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: 'Enter your password',
          icon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _obscureText
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _obscureText = !_obscureText;
                });
              }
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


