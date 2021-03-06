import 'package:flutter/material.dart';



enum ViewState { Ideal, Busy }
enum AuthStater { SignIn, SignUp }
enum ImageMode { Camera, Gallery }





class AppColors {
  static const Color lightBlue = Color(0xFFB5E6EB);
  static const Color lightGreen = Color(0xFFD5E8DB);
  static const Color green = Color(0xFFADE2CF);
  static const Color darkGreen = Color(0xFF158443);
  static const Color orange = Color(0xFFDCB5A8);
  static const Color blue = Color(0xFF61B3C3);
  static const Color indigo = Color(0xFF7C6DAF);
  static const Color red = Color(0xFFD5463C);
  static const Color navy = Color(0xFF0B0F26);
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
