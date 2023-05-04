import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workos_arabic/core/constant/constants.dart';
import 'package:workos_arabic/core/constant/size_config.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';
import 'package:workos_arabic/core/services/global_method.dart';
import 'package:workos_arabic/user_state.dart';

class MyAcountScreen extends StatefulWidget {
  final String userID;

  const MyAcountScreen({required this.userID});
  @override
  State<MyAcountScreen> createState() => _MyAcountScreenState();
}

class _MyAcountScreenState extends State<MyAcountScreen> {
  //=======
  FirebaseAuth _auth = FirebaseAuth.instance;
  //=======
  // ignore: unused_field
  bool _isLoading = false;
  String? imageUrl;
  String name = "";
  String job = "";
  String joinedAt = "";
  String email = "";
  String phoneNumber = "";
  bool _isSameUser = false;
  //=======
  @override
  void initState() {
    super.initState();
    getUserData();
  }

//=========
  void getUserData() async {
    _isLoading = true;
    print("uid ......>>>${widget.userID}");
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get("email");
          name = userDoc.get("name");
          phoneNumber = userDoc.get("phoneNumber");
          job = userDoc.get("postionInCompany");
          imageUrl = userDoc.get("userImageUrl");
          Timestamp joinedAtTimeStamp = userDoc.get("createdAt");
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = "${joinedDate.year}-${joinedDate.month}-${joinedDate.day}";
        });

        User? user = _auth.currentUser;
        String _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
        print('_isSameUser $_isSameUser');
      }
    } catch (err) {
      GlobalMethods.showErroreDialog(error: "$err", context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

//=========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Container(
              width: SizeConfig.defaultSize! * 6,
              height: SizeConfig.defaultSize! * 6,
              child: CircularProgressIndicator(
                  color: Colors.pink.shade500,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            ))
          : Stack(children: [
              Positioned(
                left: SizeConfig.defaultSize! * 3,
                top: SizeConfig.defaultSize! * 5,
                child: InkWell(
                  onTap: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(
                        fontSize: SizeConfig.defaultSize! * 3.5,
                        fontStyle: FontStyle.italic,
                        color: Constants.darkBlue),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.defaultSize! * 1.2),
                  height: SizeConfig.screenHeight! * 0.55,
                  width: SizeConfig.screenWidth! * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      VirtecalSpace(8),
                      Text(
                        // ignore: unnecessary_null_comparison
                        name == null
                            ? ""
                            : name, //if name not requer give "" if no give name ...
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize! * 1.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      VirtecalSpace(1),
                      Text(
                        "${job} Since joined ${joinedAt}",
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize! * 1.8,
                            color: Constants.darkBlue),
                      ),
                      VirtecalSpace(1),
                      Divider(
                        thickness: 1,
                      ),
                      VirtecalSpace(1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Contact Info",
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize! * 2.6,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Icon(Icons.arrow_drop_down_outlined)
                              ],
                            ),
                            VirtecalSpace(1),
                            socialInfo(label: "Email : ", content: email),
                            VirtecalSpace(1),
                            socialInfo(
                                label: "Phone number : ", content: phoneNumber),
                            VirtecalSpace(3),
                            Divider(thickness: 1),
                            VirtecalSpace(3),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      socialButtons(
                                          color: Colors.green,
                                          icon: FontAwesome.whatsapp,
                                          fct: () {
                                            _openWhatsAppChat();
                                          }),
                                      socialButtons(
                                          color: Colors.red,
                                          icon: Icons.mail_outline_outlined,
                                          fct: () {
                                            _mailTo();
                                          }),
                                      socialButtons(
                                          color: Colors.purple,
                                          icon: Icons.call_outlined,
                                          fct: () {
                                            _callPhoneNumber();
                                          }),
                                    ],
                                  ),

                            !_isSameUser
                                ? Container()
                                : MaterialButton(
                                    onPressed: () {
                                      _logout(context);
                                    },
                                    color: Colors.pink.shade700,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide.none),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            "Logout",
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
                                    )) //if the same acount give logout if not give free contaner...
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              Positioned(
                  left: SizeConfig.defaultSize! * 16,
                  top: SizeConfig.defaultSize! * 17,
                  child: Container(
                    width: SizeConfig.screenWidth! * 0.26,
                    height: SizeConfig.screenWidth! * 0.26,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 8,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              imageUrl == null
                                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                  : imageUrl!,
                            ),
                            fit: BoxFit.fill)),
                  ))
            ]),
    );
  }

  void _openWhatsAppChat() async {
    // String phoneNumber = "20128910495";
    var whatsappUrl = 'https://wa.me/$phoneNumber?text=HelloThere';
    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrlString(whatsappUrl);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _mailTo() async {
    // String emailUser = "mohamedsame0111@gmail.com";
    var url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }

  void _callPhoneNumber() async {
    // String telUser = "01289103192";
    var phoneUrl = 'tel://$phoneNumber';
    if (await canLaunchUrlString(phoneUrl)) {
      launchUrlString(phoneUrl);
    } else {
      throw "Error occured coulnd\'t open link";
    }
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
          "Do you want sign out",
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

  Widget socialInfo({required String label, required String content}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: SizeConfig.defaultSize! * 2.3,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            content,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: SizeConfig.defaultSize! * 1.5,
              color: Constants.darkBlue,
            ),
          ),
        )
      ],
    );
  }

  Widget socialButtons(
      {required Color color, required IconData icon, required Function fct}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }
}
