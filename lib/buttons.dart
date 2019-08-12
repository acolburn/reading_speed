import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({@required this.buttonText, @required this.onPress});

  final Function onPress;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
//      color: Theme.of(context).primaryColor,
//      textColor: Colors.white,
      textColor: Color(0xFF8D8E98),
//      splashColor: Theme.of(context).accentColor,
      onPressed: onPress,
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

const kNumberTextStyle = TextStyle(
  fontSize: 60.0,
  fontWeight: FontWeight.w900,
); // labelTextStyle
