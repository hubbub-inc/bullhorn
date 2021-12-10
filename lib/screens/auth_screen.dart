import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blips/providers/auth_provider.dart';
import 'package:blips/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  AuthScreen({required this.emailController, required this.passwordController});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        body:  Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
                    children: [

    RoundedButton(
    text: "LOGIN",
    press: () {

    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) {
    return LoginScreen();
    },
    ),
    );
    },
    ),
    RoundedButton(
    text: "SIGN UP",

    textColor: Colors.black,
    press: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SignUpScreen();
            },
          ));
    }),]))));


  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  late String username, password;
    @override
      Widget build(BuildContext context) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context);
  Size size = MediaQuery.of(context).size;
  return Scaffold(
          body: SingleChildScrollView(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Text(
  "SIGNUP",
  style: TextStyle(fontWeight: FontWeight.bold),
  ),
  SizedBox(height: size.height * 0.03),

  RoundedInputField(
  hintText: "Your Email",
  onChanged: (value) {
    username = value;
      },
  ),
  RoundedPasswordField(
  onChanged: (value) {
      password= value;
      }
  ),
  RoundedButton(
  text: "SIGNUP",
  press: () {
              AuthService().register(username,
                  password,
                  authProvider);
              Navigator.pop(context);
      },
  ),
  SizedBox(height: size.height * 0.03),
  AlreadyHaveAnAccountCheck(
  login: false,
  press: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) {
  return LoginScreen();
  },
  ),
  );
  },
  )])));
  }
  }

class LoginScreen extends StatefulWidget {
    @override
  _LoginScreenState createState() => _LoginScreenState();
  }
  class _LoginScreenState extends State<LoginScreen> {
  late String username, password;

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  AuthProvider authProvider = Provider.of<AuthProvider>(context);


  return Scaffold(
      body: SingleChildScrollView(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Text(
  "LOGIN",
  style: TextStyle(fontWeight: FontWeight.bold),
  ),
  SizedBox(height: size.height * 0.03),

  SizedBox(height: size.height * 0.03),
  RoundedInputField(
  hintText: "Your Email",
  onChanged: (value) {
    username = value;
  },
  ),
  RoundedPasswordField(
  onChanged: (value) {
    password = value;
  },
  ),
  RoundedButton(
  text: "LOGIN",
  press: () {
    AuthService().signIn(username,
                    password,
                    authProvider);
    Navigator.pop(context);
  },
  )])));
  }
  }

  class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
  Key? key,
  required this.hintText,
  this.icon = Icons.person,
  required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return TextFieldContainer(
  child: TextField(
  onChanged: onChanged,
  cursorColor: kPrimaryColor,
  decoration: InputDecoration(
  icon: Icon(
  icon,
  color: kPrimaryColor,
  ),
  hintText: hintText,
  border: InputBorder.none,
  ),
  ),
  );
  }
  }

  class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
  Key? key,
  required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Container(
  margin: EdgeInsets.symmetric(vertical: 10),
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  width: size.width * 0.8,
  decoration: BoxDecoration(
  color: kPrimaryLightColor,
  borderRadius: BorderRadius.circular(29),
  ),
  child: child,
  );
  }
  }

  const kPrimaryColor = Color(0xFF6F35A5);
  const kPrimaryLightColor = Color(0xFFF1E6FF);

  class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
  Key? key,
  required this.text,
  required this.press,
  this.color = kPrimaryColor,
  this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Container(
  margin: EdgeInsets.symmetric(vertical: 10),
  width: size.width * 0.8,
  child: ClipRRect(
  borderRadius: BorderRadius.circular(29),
  child: newElevatedButton(),
  ),
  );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
  return ElevatedButton(
  child: Text(
  text,
  style: TextStyle(color: textColor),
  ),
  onPressed: () => press(),
  style: ElevatedButton.styleFrom(
  primary: color,
  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  textStyle: TextStyle(
  color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
  );
  }
  }


  class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
  Key? key,
  required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return TextFieldContainer(
  child: TextField(
  obscureText: true,
  onChanged: onChanged,
  cursorColor: kPrimaryColor,
  decoration: InputDecoration(
  hintText: "Password",
  icon: Icon(
  Icons.lock,
  color: kPrimaryColor,
  ),
  suffixIcon: Icon(
  Icons.visibility,
  color: kPrimaryColor,
  ),
  border: InputBorder.none,
  ),
  ),
  );
  }
  }

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}