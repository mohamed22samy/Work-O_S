import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/core/constant/size_config.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';
import 'package:workos_arabic/screens/auth/foreget_password.dart';
import 'package:workos_arabic/screens/auth/signup.dart';

import '../../core/services/global_method.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  //========
  late TextEditingController _emailTextController =
      TextEditingController(text: "");
  late TextEditingController _passwordTextController =
      TextEditingController(text: "");
  //========
  FocusNode _passFocusNode = FocusNode();
  //========
  bool _obscureText = true;
  //========
  late AnimationController _animationController;
  late Animation<double> _animation;
  //========
  final _loginFormKey = GlobalKey<FormState>();
  //========
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //========
  bool _isLoading = false;
  //========
  @override
  void dispose() {
    _animationController.dispose();
    //=========
    _emailTextController.dispose();
    _passwordTextController.dispose();
    //=========
    _passFocusNode.dispose();

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

  void submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.trim());
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
                "Login",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              VirtecalSpace(1),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Don\'t have an acount?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: "  "),
                  TextSpan(
                      text: "Register",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen())),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              VirtecalSpace(5),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
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
                      onEditingComplete: submitFormOnLogin,
                      focusNode: _passFocusNode,
                      textInputAction: TextInputAction.done,
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
                  ],
                ),
              ),
              VirtecalSpace(2),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen()));
                    },
                    child: Text(
                      "Forget password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    )),
              ),
              VirtecalSpace(8),
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
                      onPressed: submitFormOnLogin,
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
                              "Login",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          HorizintalSpace(1),
                          Icon(
                            Icons.login,
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
}
