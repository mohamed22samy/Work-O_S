import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/screens/auth/login.dart';
import 'package:workos_arabic/screens/tasks/tasks_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          print("User didn\'t login yet");
          return LoginScreen();
        } else if (userSnapshot.hasData) {
          print("User is logged in");
          return TasksScreen();
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text(
              'An error has been occured !!',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        }
        return Scaffold(
            body: Center(
          child: Text(
            'something went wrong !!',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ));
      },
    );
  }
}
