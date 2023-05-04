import 'package:flutter/material.dart';
import 'package:workos_arabic/core/constant/space_widget.dart';

import '../../core/constant/size_config.dart';
import '../myacount_screen.dart';

// ignore: must_be_immutable
class CommentWidget extends StatelessWidget {
  CommentWidget(
      {required this.commentId,
      required this.commentBody,
      required this.commenterImageUrl,
      required this.commenterName,
      required this.commenterId});

  final String commentId;
  final String commentBody;
  final String commenterImageUrl;
  final String commenterName;
  final String commenterId;
  List<Color> _color = [
    Colors.tealAccent,
    Colors.pink,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.blue,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    _color.shuffle();
    return InkWell(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAcountScreen(
                  userID:commenterId,
                )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HorizintalSpace(1),
          Container(
            height: SizeConfig.defaultSize! * 6,
            width: SizeConfig.defaultSize! * 6,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: _color[0]),
                shape: BoxShape.circle,
                image: DecorationImage(
                    // ignore: unnecessary_null_comparison
                    image: NetworkImage(commenterImageUrl == null
                        ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                        : commenterImageUrl),
                    fit: BoxFit.fill)),
          ),
          HorizintalSpace(1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              VirtecalSpace(0.5),
              Text(
                // ignore: unnecessary_null_comparison
                commenterName == null ? "" : commenterName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.defaultSize! * 2.2,
                    color: Colors.black),
              ),
              VirtecalSpace(1),
              Text(
                // ignore: unnecessary_null_comparison
                commentBody == null ? "" : commentBody,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: SizeConfig.defaultSize! * 2,
                    color: Colors.black),
              ),
              VirtecalSpace(0.5),
            ],
          )
        ],
      ),
    );
  }
}
