import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/core/services/drawer_widget.dart';
import 'package:workos_arabic/screens/tasks/widgets/tasks_widgets.dart';

import '../../core/constant/constants.dart';
import '../../core/constant/size_config.dart';

// ignore: must_be_immutable
class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? taskCategory;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Constants.darkBlue), //color the drawer>>>>.
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Tasks",
            style: TextStyle(color: Colors.pink.shade700),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showTAskCategoryDialog(context);
                },
                icon: Icon(
                  Icons.filter_list_outlined,
                  color: Constants.darkBlue,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Tasks")
              .where('taskCategory', isEqualTo: taskCategory) //filtter..
              //.orderBy("createdAt", descending:true) //new is first or last.
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.pink.shade600),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskWidget(
                      isDone: snapshot.data!.docs[index]["isDone"],
                      taskId: snapshot.data!.docs[index]["taskId"],
                      uploadedBy: snapshot.data!.docs[index]["uploadedBy"],
                      taskTitle: snapshot.data!.docs[index]["taskTitle"],
                      taskDescription: snapshot.data!.docs[index]
                          ["taskDescription"],
                    );
                  },
                );
              } else {
                return Scaffold(
                  body: Center(child: Text("No task has been uploaded")),
                );
              }
            }
            return Scaffold(
              body: Center(child: Text("some thing went wrong")),
            );
          },
        ));
  }

  void showTAskCategoryDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Task category",
          style: TextStyle(color: Colors.pink.shade500, fontSize: 20),
        ),
        content: Container(
          width: SizeConfig.screenWidth! * 0.9,
          // height: SizeConfig.screenHeight! / 3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ConsatntList.taskCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print(
                      "taskCategoryList===>>> ${ConsatntList.taskCategoryList[index]}");
                  setState(() {
                    taskCategory = ConsatntList.taskCategoryList[index];
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Colors.red[200]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ConsatntList.taskCategoryList[index],
                        style: TextStyle(
                            color: Color(0xFF00325A),
                            fontSize: SizeConfig.defaultSize! * 2,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text("Close")),
          TextButton(
              onPressed: () {
                setState(() {
                  taskCategory = null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text("Cancel filter"))
        ],
      ),
    );
  }
}
