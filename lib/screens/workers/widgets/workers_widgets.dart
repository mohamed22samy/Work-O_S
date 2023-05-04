import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/constant/size_config.dart';
import '../../../inner_screens/myacount_screen.dart';

class WorkersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String postionInCompany;
  final String userImageUrl;
  final String userPhoneNumber;

  const WorkersWidget(
      {required this.userID,
      required this.userName,
      required this.userEmail,
      required this.postionInCompany,
      required this.userImageUrl,
      required this.userPhoneNumber});

  @override
  State<WorkersWidget> createState() => _WorkersWidgetState();
}

class _WorkersWidgetState extends State<WorkersWidget> {
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
                    builder: (context) => MyAcountScreen(
                          userID: widget.userID,
                        )));
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
              padding: EdgeInsets.only(right: 10),
              decoration:
                  BoxDecoration(border: Border(right: BorderSide(width: 1.0))),
              child: Container(
                width: SizeConfig.screenWidth! * 0.15,
                height: SizeConfig.screenWidth! * 0.15,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                          // ignore: unnecessary_null_comparison
                          widget.userImageUrl == null
                              ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                              : widget.userImageUrl,
                        ),
                        fit: BoxFit.fill)),
              )),
          title: Text(
            widget.userName,
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
                  "${widget.postionInCompany} \n${widget.userPhoneNumber}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                )
              ]),
          trailing: IconButton(
            onPressed: () {
              _mailTo();
            },
            icon: Icon(
              Icons.mail_outline,
              color: Colors.pink.shade800,
              size: 30,
            ),
          )),
    );
  }

  void _mailTo() async {
    // String emailUser = "mohamedsame0111@gmail.com";
    var url = 'mailto:${widget.userEmail}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Error occured coulnd\'t open link';
    }
  }
}
