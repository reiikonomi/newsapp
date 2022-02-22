// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping2/authentication_service.dart';
import 'package:shopping2/screens/home_screen.dart';
import 'package:shopping2/screens/login_screen.dart';

class AppBarButton extends StatefulWidget {
  const AppBarButton({Key key}) : super(key: key);

  @override
  _AppBarButtonState createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
              size: 40,
            )),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.green),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      fixedSize: const Size(200, 100)),
                  child: const Text('Sign out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
        /*child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 400,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, onPrimary: Colors.green),
                  child: const Text('Sign out'),
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  /* style: ElevatedButton.styleFrom(primary: Colors.green,  onPrimary: Colors.green),
                  child: const Text('Sign out'),*/
                ),
              ],
            )
          ],
        ),*/
      ),
    );
  }
}
