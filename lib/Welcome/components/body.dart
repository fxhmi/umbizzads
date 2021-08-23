
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umbizz/Login/login_screen.dart';
import 'package:umbizz/Signup/signup_screen.dart';
import 'package:umbizz/Welcome/components/background.dart';
import 'package:umbizz/Widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;


    return WelcomeBackground(


      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset("assets/images/umbizz_logo.png", height: 98,),

            SizedBox(height: size.height * 0.05),


            AnimatedImage(),



            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
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
            ),
            RoundedButton(
              text: "SIGN UP",
              color: Colors.deepPurple[100],
              textColor: Colors.black,
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

            ),
          ],
        ),
      ),
    );
  }
}


@override
Widget build(BuildContext context) {
  final topPadding = MediaQuery.of(context).padding.top;
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromRGBO(145, 131, 222, 1),
        Color.fromRGBO(160, 148, 227, 1),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: topPadding),
            SizedBox(height: 10),
            AnimatedImage(),
          ],
        ),
      ),
    ),
  );
}

class AnimatedImage extends StatefulWidget {
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/clouds.png'),
        SlideTransition(
          position: _animation,
          child: Image.asset('assets/images/rocket_person.png'),
        ),
      ],
    );
  }
}

