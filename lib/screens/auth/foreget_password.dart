import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/core/constant/size_config.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with TickerProviderStateMixin {
  //========
  late TextEditingController _forgetPasswordTextController =
      TextEditingController(text: "");
  //========
  late AnimationController _animationController;
  late Animation<double> _animation;
  //========
  @override
  void dispose() {
    _animationController.dispose();
    //=========
    _forgetPasswordTextController.dispose();

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

  void _forgetPaswordFCT() {
    print(
        "_forgetPasswordTextController.text ==> ${_forgetPasswordTextController.text}");
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
                "Forget password",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              VirtecalSpace(1.5),
              Text(
                "Email adress",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              VirtecalSpace(2),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: _forgetPasswordTextController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink.shade700)),
                  ),
                ),
              ),
              VirtecalSpace(10),
              MaterialButton(
                  onPressed: _forgetPaswordFCT,
                  color: Colors.pink.shade700,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide.none),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Reset now",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
