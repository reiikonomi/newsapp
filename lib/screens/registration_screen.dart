// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/src/provider.dart';
import 'package:shopping2/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping2/screens/registration_screen.dart';
import './home_screen.dart';
import './login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //editing controller
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    //firstnamefield
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      //validator: () {}
      onSaved: (value) {
        firstNameEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'First Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    //lastnamefield
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      //validator: () {}
      onSaved: (value) {
        lastNameEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Last Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    //emailfield
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Email cannot be empty!';
        }
        return null;
      },
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
      controller: passwordEditingController,
      validator: (value) {
        if (value.length < 6) {
          return 'Password must be at least 6 characters!';
        }
        return null;
      },
      onSaved: (input) => _password = input,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    //confirmpasswordfield
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      validator: (input) {
        if (input != _password) {
          return 'Password doesn\'t match!';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    // ignore: non_constant_identifier_names
    final SignUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          context.read<AuthenticationService>().signUp(
              email: emailEditingController.text.trim(),
              password: passwordEditingController.text.trim());
          /* if (firebaseUser != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }*/
          if (firebaseUser != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed Up, go to login to login'), duration: Duration(seconds: 5),)
            );
          }
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));*/
        },
        child: const Text(
          'Sign Up',
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
                      const SizedBox(height: 25),
                      firstNameField,
                      const SizedBox(height: 25),
                      lastNameField,
                      const SizedBox(height: 25),
                      emailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 25),
                      confirmPasswordField,
                      const SizedBox(height: 25),
                      SignUpButton,
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text('Already have an account?'),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen())),
                            child: const Text(
                              ' Login',
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
