import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/inner_screens/task_details.dart';

import '../../../core/services/global_method.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle;
  final String taskDescription;
  final String taskId;
  final String uploadedBy;
  final bool isDone;

  const TaskWidget(
      {required this.taskTitle,
      required this.taskDescription,
      required this.taskId,
      required this.uploadedBy,
      required this.isDone});
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                taskId: widget.taskId,
                uploadedBy: widget.uploadedBy,
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(actions: [
              TextButton(
                  onPressed: () {
                    User? user = _auth.currentUser;
                    String _uid = user!.uid;
                    if (_uid == widget.uploadedBy) {
                      FirebaseFirestore.instance
                          .collection('Tasks')
                          .doc(widget.taskId)
                          .delete();
                      Navigator.pop(context);
                    } else {
                      GlobalMethods.showErroreDialog(
                          error: 'You dont have access to delete this task',
                          context: context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ))
            ]),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
            padding: EdgeInsets.only(right: 10),
            decoration:
                BoxDecoration(border: Border(right: BorderSide(width: 1.0))),
            child: CircleAvatar(
              radius: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Image.asset(widget.isDone
                    ? 'assets/images/check.png'
                    : 'assets/images/incomplete.png'),
              ),
            )),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.linear_scale,
                color: Colors.pink,
              ),
              Text(
                widget.taskDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              )
            ]),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.pink.shade800,
          size: 30,
        ),
      ),
    );
  }
}
