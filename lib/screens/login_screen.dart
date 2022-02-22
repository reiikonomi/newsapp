// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/src/provider.dart';
import 'package:shopping2/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping2/screens/registration_screen.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    //emailfield
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      /* validator: (input){
        if (input.isEmpty){
          return 'Email can\'t be empty!';
        }
        else {
          return null;
        }
      },*/
      /*validator: (input) {

        if(input.isEmpty){
          return 'Email is required';
        }
         
       /* onSaved:
        (input) => _email = input;*/
      },*/
      onSaved: (input) => _email = input,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    //passwordfield
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (input) {
        if (input.length < 6) {
          return 'Password must be at least 6 characters!';
        }
        return null;
      },
      onSaved: (input) => _password = input,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      obscureText: true,
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,

        // ignore: void_checks
        onPressed: () {
          if (firebaseUser != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } /*else{
            return ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User does not exist, Sign Up!'), duration: Duration(seconds: 5),backgroundColor: Colors.green,)
            );
          }*/
         /* if (firebaseUser == null) {
            return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('User does not exist, or password is incorrect!'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green,
            ));
          }*/

          context.read<AuthenticationService>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));*/
        },
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      emailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 25),
                      loginButton,
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text('Don\'t have an account?'),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen())),
                            child: const Text(
                              ' Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.green),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
