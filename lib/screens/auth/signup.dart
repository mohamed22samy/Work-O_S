import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workos_arabic/core/constant/size_config.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';
import 'package:workos_arabic/core/services/global_method.dart';
import 'package:workos_arabic/screens/auth/login.dart';

import '../../core/constant/constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  //========
  late TextEditingController _fullnameTextController =
      TextEditingController(text: "");
  late TextEditingController _emailTextController =
      TextEditingController(text: "");
  late TextEditingController _passwordTextController =
      TextEditingController(text: "");
  late TextEditingController _phoneNumberTextController =
      TextEditingController(text: "");
  late TextEditingController _postionCPTextController =
      TextEditingController(text: "");
  //========
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _postionFocusNode = FocusNode();
  //========
  bool _obscureText = true;
  //========
  late AnimationController _animationController;
  late Animation<double> _animation;
  //========
  final _SignUpFormKey = GlobalKey<FormState>();
  //========
  File? imageFile;
  //========
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //========
  bool _isLoading = false;
  //========
  String? url;
  //========
  @override
  void dispose() {
    _animationController.dispose();
    //=========
    _fullnameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _postionCPTextController.dispose();
    _phoneNumberTextController.dispose();
    //=========
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _postionFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void submitFormOnSignUp() async {
    final isValid = _SignUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethods.showErroreDialog(
            error: "Please pick up an image", context: context);
        return;
      }
      //======
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.trim());

        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        //=========
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child(_uid + ".jpg");
        await ref.putFile(imageFile!);
        url = await ref.getDownloadURL();
        //=========
        await FirebaseFirestore.instance.collection("users").doc(_uid).set({
          'createdAt': Timestamp.now(),
          'id': _uid,
          'name': _fullnameTextController.text,
          'email': _emailTextController.text,
          'phoneNumber': _phoneNumberTextController.text,
          'postionInCompany': _postionCPTextController.text,
          'userImageUrl': url,
        });
        //===========
        Navigator.canPop(context) ? Navigator.pop(context) : null;
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
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        CachedNetworkImage(
          imageUrl:
              "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
          placeholder: (context, url) => Image.asset(
            "assets/images/wallpaper.jpg",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: FractionalOffset(_animation.value, 0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              VirtecalSpace(10),
              Text(
                "Register",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              VirtecalSpace(1),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Already have an acount?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: "  "),
                  TextSpan(
                      text: "Login",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen())),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              VirtecalSpace(5),
              Form(
                key: _SignUpFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return "Field can\'t be missing (enter full name)";
                              }
                              return null;
                            },
                            controller: _fullnameTextController,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: "Full name",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.pink.shade700)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: SizeConfig.screenWidth! * 0.24,
                                width: SizeConfig.screenWidth! * 0.24,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageFile == null
                                        ? Image.network(
                                            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            imageFile!,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  _showChooseOptionDialog();
                                },
                                child: Container(
                                  height: SizeConfig.defaultSize! * 4.5,
                                  width: SizeConfig.defaultSize! * 4.5,
                                  decoration: BoxDecoration(
                                      color: Colors.pink,
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      imageFile == null
                                          ? Icons.add_a_photo
                                          : Icons.edit_outlined,
                                      size: SizeConfig.defaultSize! * 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                    VirtecalSpace(1),
                    TextFormField(
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_passFocusNode),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !value.contains("@") ||
                            !value.contains(".")) {
                          return "Please enter a valid email adress";
                        }
                        return null;
                      },
                      controller: _emailTextController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                    VirtecalSpace(1),
                    TextFormField(
                      focusNode: _passFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_phoneNumberFocusNode),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return "Please enter a valid password ";
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                      controller: _passwordTextController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              )),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                    VirtecalSpace(1),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      onEditingComplete: submitFormOnSignUp,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can\'t be missing";
                        }
                        return null;
                      },
                      focusNode: _phoneNumberFocusNode,
                      controller: _phoneNumberTextController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: "Phone number",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                    VirtecalSpace(1),
                    InkWell(
                      onTap: () {
                        showJobDialog();
                      },
                      child: TextFormField(
                        enabled: false,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: submitFormOnSignUp,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field can\'t be missing";
                          }
                          return null;
                        },
                        focusNode: _postionFocusNode,
                        controller: _postionCPTextController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Postion in the company ...",
                            hintStyle: TextStyle(color: Colors.white),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pink.shade700)),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                    ),
                  ],
                ),
              ),
              VirtecalSpace(10),
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
                  : MaterialButton(
                      onPressed: submitFormOnSignUp,
                      color: Colors.pink.shade700,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide.none),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          HorizintalSpace(1),
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                          )
                        ],
                      ))
            ],
          ),
        )
      ]),
    );
  }

  void _pickImageWithCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
      // setState(() {
      //   imageFile = File(pickedFile!.path);
      // })
      _cropImage(pickedFile!.path);
    } catch (error) {
      GlobalMethods.showErroreDialog(error: "$error", context: context);
    }
  }

  void _pickImageWithGallery() async {
   try {
     XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    _cropImage(pickedFile!.path);
     
   } catch (error) {
      GlobalMethods.showErroreDialog(error: "$error", context: context);
     
   }
  }

  void _cropImage(filepath) async {
    File? cropImage = await ImageCropper()
        .cropImage(sourcePath: filepath, maxHeight: 1080, maxWidth: 1080);
    if (cropImage != null) {
      setState(() {
        imageFile = cropImage;
      });
    }
  }

  void _showChooseOptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                "Please choose an option",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            VirtecalSpace(2),
            Padding(
              padding: const EdgeInsets.all(0),
              child: InkWell(
                onTap: () {
                  _pickImageWithCamera();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_outlined,
                      color: Colors.pink.shade600,
                    ),
                    HorizintalSpace(1),
                    Text(
                      "Camera",
                      style: TextStyle(
                        color: Colors.pink.shade600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtecalSpace(2),
            Padding(
              padding: const EdgeInsets.all(0),
              child: InkWell(
                onTap: () {
                  _pickImageWithGallery();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_album,
                      color: Colors.pink.shade600,
                    ),
                    HorizintalSpace(1),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        color: Colors.pink.shade600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showJobDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Jobs",
          style: TextStyle(color: Colors.pink.shade500, fontSize: 20),
        ),
        content: Container(
          width: SizeConfig.screenWidth! * 0.9,
          // height: SizeConfig.screenHeight! / 3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ConsatntList.jobsList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _postionCPTextController.text =
                        ConsatntList.jobsList[index];
                  });
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Colors.red[200]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ConsatntList.jobsList[index],
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
        ],
      ),
    );
  }
}
