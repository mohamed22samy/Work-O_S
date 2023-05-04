import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/core/constant/constants.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';
import 'package:workos_arabic/inner_screens/add_tasks_screen.dart';
import 'package:workos_arabic/inner_screens/myacount_screen.dart';
import 'package:workos_arabic/screens/tasks/tasks_screen.dart';
import 'package:workos_arabic/screens/workers/all_worker_screen.dart';

import '../../user_state.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.cyan),
          child: Column(children: [
            Flexible(
                flex: 4,
                child: Image.asset(
                  "assets/images/logo.png",
                )),
            VirtecalSpace(2),
            Flexible(
                flex: 2,
                child: Text(
                  "Work OS",
                  style: TextStyle(
                      color: Constants.darkBlue,
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ))
          ]),
        ),
        VirtecalSpace(2),
        _listTileWidget(
            color: Colors.cyan,
            icon: Icons.task_outlined,
            onTap: () {
              _navigatorTotaskScreen(context);
            },
            text: "All tasks"),
        VirtecalSpace(1),
        _listTileWidget(
            color: Colors.cyan,
            icon: Icons.settings_outlined,
            onTap: () {
              _navigatorToMyAcountScreen(context);
            },
            text: "My account"),
        VirtecalSpace(1),
        _listTileWidget(
            color: Colors.cyan,
            icon: Icons.workspaces_outlined,
            onTap: () {
              _navigatorToAllWorkerScreen(context);
            },
            text: "Registered Workers"),
        VirtecalSpace(1),
        _listTileWidget(
            color: Colors.cyan,
            icon: Icons.add_task_outlined,
            onTap: () {
              _navigatorToAddtaskScreen(context);
            },
            text: "Add task"),
        VirtecalSpace(1),
        Divider(thickness: 1),
        VirtecalSpace(1),
        _listTileWidget(
            color: Colors.red,
            icon: Icons.logout_outlined,
            onTap: () {
              _logout(context);
            },
            text: "Lougout")
      ]),
    );
  }

  void _navigatorToMyAcountScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid =  user!.uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAcountScreen(
                  userID:uid,
                )));
  }

  void _navigatorToAllWorkerScreen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AllWorkersScreen()));
  }

  void _navigatorToAddtaskScreen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
  }

  void _navigatorTotaskScreen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TasksScreen()));
  }

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.cyan,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sign Out"),
            )
          ],
        ),
        content: Text(
          "Don you want sign out",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 20,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.pink.shade500,
                  fontSize: 20,
                ),
              )),
          TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UserState()));
              },
              child: Text("Ok",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 20,
                  )))
        ],
      ),
    );
  }

  Widget _listTileWidget(
      {required String text,
      required IconData icon,
      required Function() onTap,
      required Color color}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
            color: Constants.darkBlue,
            fontSize: 20,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
