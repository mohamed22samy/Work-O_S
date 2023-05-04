import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:workos_arabic/core/constant/constants.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';

import '../core/constant/size_config.dart';
import '../core/services/drawer_widget.dart';
import '../core/services/global_method.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //==========
  TextEditingController _categoryController =
      TextEditingController(text: 'Task Category ...');
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _deadlineDateController =
      TextEditingController(text: 'pick up a date ...');
  //==========
  final _uploadFormKey = GlobalKey<FormState>();
  //==========
  DateTime? picked;
  //==========
  bool _isLoading = false;
  //==========
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //========
  Timestamp? _taskDeadLineDateTimeStamp;
  //========
  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineDateController.dispose();
    super.dispose();
  }

  void uploadFct() async {
    final isValid = _uploadFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        //=========
        final taskID = Uuid().v4();
        //=========
        await FirebaseFirestore.instance.collection("Tasks").doc(taskID).set({
          'taskId': taskID,
          'uploadedBy': _uid,
          'taskCategory': _categoryController.text,
          'taskTitle': _titleController.text,
          'taskDescription': _descriptionController.text,
          'taskDeadlineDate': _deadlineDateController.text,
          'taskDeadLineDateTimeStamp': _taskDeadLineDateTimeStamp,
          'taskComment': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        //===========
        Fluttertoast.showToast(
            msg: "Task has been uploaded succes",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 14.0);
        //===========
        _categoryController.clear();
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
           _categoryController.text = 'Task Category ...';
          _deadlineDateController.text = 'pick up a date ...';
        });
        //===========

      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErroreDialog(
            error: error.toString(), context: context);
      }
      //======
    } else {
      print("Form Not Valid");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, right: 7, left: 7, bottom: 7),
        child: SingleChildScrollView(
          child: Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "All field are required",
                    style: TextStyle(
                        fontSize: 25,
                        color: Constants.darkBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Form(
                key: _uploadFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textLable(lableText: "Task category*"),
                    _textFormField(
                      validator: (value) {
                        if (value!.isEmpty || !value.contains(">")) {
                          return "Something is wrong";
                        }
                        return null;
                      },
                      valueKey: "TaskCategory",
                      maxLength: 100,
                      controller: _categoryController,
                      enabled: false,
                      fct: () {
                        showTAskCategoryDialog();
                      },
                    ),
                    _textLable(lableText: "Task tilte*"),
                    _textFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Something is wrong";
                        }
                        return null;
                      },
                      valueKey: "Tasktilte",
                      maxLength: 100,
                      controller: _titleController,
                      enabled: true,
                      fct: () {},
                    ),
                    _textLable(lableText: "Task Description*"),
                    _textFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Something is wrong";
                        }
                        return null;
                      },
                      valueKey: "TaskDescription",
                      maxLength: 1000,
                      controller: _descriptionController,
                      enabled: true,
                      fct: () {},
                    ),
                    _textLable(lableText: "Task Deadline date*"),
                    _textFormField(
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("-")) {
                          return "Something is wrong";
                        }
                        return null;
                      },
                      valueKey: "DeadlineDate",
                      maxLength: 100,
                      controller: _deadlineDateController,
                      enabled: false,
                      fct: () {
                        _pickDate();
                      },
                    ),
                    VirtecalSpace(2),
                    _isLoading
                        ? Center(
                            child: Container(
                            width: SizeConfig.defaultSize! * 6,
                            height: SizeConfig.defaultSize! * 6,
                            child: CircularProgressIndicator(
                                color: Colors.pink.shade500,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor),
                          ))
                        : Center(
                            child: MaterialButton(
                                onPressed: uploadFct,
                                color: Colors.pink.shade700,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide.none),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Text(
                                        "Upload",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    HorizintalSpace(1),
                                    Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                    ),
                                  ],
                                )),
                          ),
                    VirtecalSpace(5),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  void showTAskCategoryDialog() {
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
                  setState(() {
                    _categoryController.text =
                        ConsatntList.taskCategoryList[index];
                  });
                  Navigator.pop(context);
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
                            fontSize: SizeConfig.defaultSize! * 1.8,
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
        ],
      ),
    );
  }

  void _pickDate() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        _taskDeadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
        _deadlineDateController.text =
            "${picked!.year}-${picked!.month}-${picked!.day}";
      });
    }
  }

  _textLable({String? lableText}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        lableText!,
        style: TextStyle(
            fontSize: 18,
            color: Colors.pink.shade800,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  _textFormField(
      {required String valueKey,
      required int maxLength,
      required TextEditingController controller,
      required bool enabled,
      required void Function()? fct,
      required String? Function(String?) validator}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: fct,
        child: TextFormField(
          controller: controller,
          validator: validator
          //  (value) {
          //   if (value!.isEmpty) {
          //     return "Field is missing";
          //   }
          //   return null;
          // },
          ,
          cursorColor: Constants.darkBlue,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink.shade800),
            ),
          ),
        ),
      ),
    );
  }
}
