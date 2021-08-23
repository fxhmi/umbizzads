// @dart=2.9
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {

  final Widget child;
  const LoginBackground({
    Key key,
    @required this.child,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(145, 131, 222, 1),
          Color.fromRGBO(160, 148, 227, 1),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/main_top.png",
              width: size.width*0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/main_bottom.png",
              width: size.width*0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
