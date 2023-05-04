import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';
import 'package:workos_arabic/inner_screens/widgets/comment_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constant/constants.dart';
import '../core/constant/size_config.dart';
import '../core/services/global_method.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailsScreen({required this.taskId, required this.uploadedBy});
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isCommenting = false;
  var contentsInfo = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Constants.darkBlue);

  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  String? _authorName;
  // ignore: unused_field
  String? _authorPosition;
  String? taskDescription;
  String? taskTitle;
  // ignore: unused_field
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? deadlineDate;
  String? postedDate;
  String? userImageUrl;
  bool isDeadlineAvailable = false;
  // ignore: unused_field
  bool _isLoading = false;
  //==============
  TextEditingController _commentController = TextEditingController(text: '');
  //==============
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('postionInCompany');
          userImageUrl = userDoc.get('userImageUrl');
        });
      }
      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('Tasks')
          .doc(widget.taskId)
          .get();
      // ignore: unnecessary_null_comparison
      if (taskDatabase == null) {
        return;
      } else {
        setState(() {
          taskDescription = taskDatabase.get('taskDescription');
          taskTitle = taskDatabase.get('taskTitle');
          _isDone = taskDatabase.get('isDone');
          deadlineDate = taskDatabase.get('taskDeadlineDate');
          deadlineDateTimeStamp = taskDatabase.get('taskDeadLineDateTimeStamp');
          postedDateTimeStamp = taskDatabase.get('createdAt');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
          var date = deadlineDateTimeStamp!.toDate();
          isDeadlineAvailable = date.isAfter(DateTime.now());
        });
      }
    } catch (error) {
      GlobalMethods.showErroreDialog(
          error: 'An error occured', context: context);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back",
              style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 3.5,
                  fontStyle: FontStyle.italic,
                  color: Constants.darkBlue),
            ),
          )),
      body: _isLoading
          ? Center(
              child: Container(
              width: SizeConfig.defaultSize! * 6,
              height: SizeConfig.defaultSize! * 6,
              child: CircularProgressIndicator(
                  color: Colors.pink.shade500,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  VirtecalSpace(1),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      taskTitle == null ? "" : taskTitle!,
                      style: TextStyle(
                          fontSize: SizeConfig.defaultSize! * 3,
                          fontWeight: FontWeight.bold,
                          color: Constants.darkBlue),
                    ),
                  ),
                  VirtecalSpace(1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "uploaded by",
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize! * 1.8,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.darkBlue),
                                ),
                                Spacer(),
                                Container(
                                  height: SizeConfig.defaultSize! * 6,
                                  width: SizeConfig.defaultSize! * 6,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3,
                                          color: Colors.pink.shade800),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(userImageUrl ==
                                                  null
                                              ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                              : userImageUrl!),
                                          fit: BoxFit.fill)),
                                ),
                                HorizintalSpace(1),
                                Column(
                                  children: [
                                    Text(
                                      _authorName == null ? "" : _authorName!,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.defaultSize! * 1.5,
                                          color: Constants.darkBlue),
                                    ),
                                    Text(
                                      _authorPosition == null
                                          ? ""
                                          : _authorPosition!,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize:
                                              SizeConfig.defaultSize! * 1.5,
                                          color: Constants.darkBlue),
                                    )
                                  ],
                                )
                              ],
                            ),
                            VirtecalSpace(1),
                            Divider(
                              thickness: 1,
                            ),
                            VirtecalSpace(1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Uploaded on:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.defaultSize! * 2.2,
                                          color: Constants.darkBlue),
                                    ),
                                    VirtecalSpace(0.5),
                                    Text(
                                      "Deadline date: on:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.defaultSize! * 2.2,
                                          color: Constants.darkBlue),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      postedDate == null ? "" : postedDate!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: SizeConfig.defaultSize! * 2,
                                          color: Constants.darkBlue),
                                    ),
                                    VirtecalSpace(0.5),
                                    Text(
                                      deadlineDate == null ? "" : deadlineDate!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: SizeConfig.defaultSize! * 2,
                                          color: Colors.red),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            VirtecalSpace(1.5),
                            Center(
                              child: Text(
                                isDeadlineAvailable
                                    ? "Still have time"
                                    : "No time left",
                                style: TextStyle(
                                    fontSize: SizeConfig.defaultSize! * 1.8,
                                    color: isDeadlineAvailable
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ),
                            VirtecalSpace(1.5),
                            Divider(
                              thickness: 1,
                            ),
                            VirtecalSpace(1.5),
                            Text(
                              "Done state:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.defaultSize! * 2.2,
                                  color: Constants.darkBlue),
                            ),
                            VirtecalSpace(1),
                            Row(
                              children: [
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      String _uid = user!.uid;
                                      if (_uid == widget.uploadedBy) {
                                        FirebaseFirestore.instance
                                            .collection('Tasks')
                                            .doc(widget.taskId)
                                            .update({'isDone': true});
                                        getData();
                                      } else {
                                        GlobalMethods.showErroreDialog(
                                            error:
                                                'You can\'t perform this action',
                                            context: context);
                                      }
                                    },
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                          decoration: _isDone == true
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                              SizeConfig.defaultSize! * 1.7,
                                          color: Constants.darkBlue),
                                    ),
                                  ),
                                ),
                                HorizintalSpace(1),
                                Opacity(
                                  opacity: _isDone == true ? 1 : 0,
                                  child: Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ),
                                HorizintalSpace(5),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      User? user = _auth.currentUser;
                                      String _uid = user!.uid;
                                      if (_uid == widget.uploadedBy) {
                                        FirebaseFirestore.instance
                                            .collection('Tasks')
                                            .doc(widget.taskId)
                                            .update({'isDone': false});
                                        getData();
                                      } else {
                                        GlobalMethods.showErroreDialog(
                                            error:
                                                'You can\'t perform this action',
                                            context: context);
                                      }
                                    },
                                    child: Text(
                                      "Not done",
                                      style: TextStyle(
                                          decoration: _isDone == false
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                              SizeConfig.defaultSize! * 1.7,
                                          color: Constants.darkBlue),
                                    ),
                                  ),
                                ),
                                HorizintalSpace(1),
                                Opacity(
                                  opacity: _isDone == false ? 1 : 0,
                                  child: Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            VirtecalSpace(1.5),
                            Divider(
                              thickness: 1,
                            ),
                            VirtecalSpace(1.5),
                            Text(
                              "Task description:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.defaultSize! * 2.2,
                                  color: Constants.darkBlue),
                            ),
                            VirtecalSpace(1),
                            Text(
                              taskDescription == null ? "" : taskDescription!,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: SizeConfig.defaultSize! * 1.77,
                                  color: Constants.darkBlue),
                            ),
                            VirtecalSpace(1.5),
                            Divider(
                              thickness: 1,
                            ),
                            VirtecalSpace(1.5),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 800),
                              child: _isCommenting
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                          Flexible(
                                            flex: 3,
                                            child: TextField(
                                              controller: _commentController,
                                              cursorColor: Colors.pink,
                                              maxLength: 200,
                                              style: TextStyle(
                                                  color: Constants.darkBlue),
                                              keyboardType: TextInputType.text,
                                              maxLines: 6,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .pink))),
                                            ),
                                          ),
                                          Flexible(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: MaterialButton(
                                                      onPressed: () async {
                                                        if (_commentController
                                                                .text.length <
                                                            7) {
                                                          GlobalMethods
                                                              .showErroreDialog(
                                                                  error:
                                                                      "Comment can be less than 7 characteres",
                                                                  context:
                                                                      context);
                                                        } else {
                                                          final _generatedId =
                                                              Uuid().v4();
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Tasks")
                                                              .doc(
                                                                  widget.taskId)
                                                              .update({
                                                            "taskComment":
                                                                FieldValue
                                                                    .arrayUnion([
                                                              {
                                                                'userId': widget
                                                                    .uploadedBy,
                                                                'commentsId':
                                                                    _generatedId,
                                                                'name':_authorName
                                                                    ,
                                                                'commentBody':
                                                                    _commentController
                                                                        .text,
                                                                'time':
                                                                    Timestamp
                                                                        .now(),
                                                                'userImageUrl':
                                                                    userImageUrl
                                                              }
                                                            ]),
                                                          });
                                                          //=====================
                                                          await Fluttertoast.showToast(
                                                              msg:
                                                                  " your comment has been uploaded succes",
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              fontSize: 14.0);
                                                          _commentController
                                                              .clear();
                                                        }
                                                        setState(() {});
                                                      },
                                                      color:
                                                          Colors.pink.shade700,
                                                      elevation: 10,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              side: BorderSide
                                                                  .none),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize! *
                                                              1,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          child: Text(
                                                            "Post",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .defaultSize! *
                                                                    1.5,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _isCommenting =
                                                              !_isCommenting;
                                                        });
                                                      },
                                                      color: Colors.white,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              side: BorderSide
                                                                  .none),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize! *
                                                              1,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .defaultSize! *
                                                                    1.2,
                                                                color: Colors
                                                                    .pink
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ])
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                            });
                                          },
                                          color: Colors.pink.shade700,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide.none),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.defaultSize! * 1,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "Add a Comment",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .defaultSize! *
                                                        2,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            VirtecalSpace(1.5),
                            FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("Tasks")
                                    .doc(widget.taskId)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.pink.shade600,
                                    ));
                                  } else {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }
                                  }

                                  return ListView.separated(
                                    itemCount:
                                        snapshot.data!['taskComment'].length,
                                    reverse: true,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, index) {
                                      return CommentWidget(
                                        commentId:
                                            snapshot.data!['taskComment']
                                                [index]["commentsId"],
                                        commenterId:
                                            snapshot.data!['taskComment']
                                                [index]["userId"],
                                        commenterName:
                                            snapshot.data!['taskComment']
                                                [index]["name"],
                                        commenterImageUrl:
                                            snapshot.data!['taskComment']
                                                [index]["userImageUrl"],
                                        commentBody:
                                            snapshot.data!['taskComment']
                                                [index]["commentBody"],
                                      );
                                    },
                                    separatorBuilder: (ctx, index) {
                                      return Divider(
                                        thickness: 1,
                                      );
                                    },
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
