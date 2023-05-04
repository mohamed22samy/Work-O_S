import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos_arabic/core/services/drawer_widget.dart';
import 'package:workos_arabic/screens/workers/widgets/workers_widgets.dart';

import '../../core/constant/constants.dart';
import '../../core/constant/size_config.dart';

// ignore: must_be_immutable
class AllWorkersScreen extends StatelessWidget {
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
            "All Workers",
            style: TextStyle(color: Colors.pink.shade700),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
                    return WorkersWidget(
                      userID:snapshot.data!.docs[index]["id"] ,
                      userName:snapshot.data!.docs[index]["name"] ,
                      userEmail: snapshot.data!.docs[index]["email"],
                      postionInCompany:snapshot.data!.docs[index]["postionInCompany"] ,
                      userImageUrl: snapshot.data!.docs[index]["userImageUrl"],
                      userPhoneNumber: snapshot.data!.docs[index]["phoneNumber"],
                    );
                  },  
                );
              } else {
                return Scaffold(
                  body: Text("No workers has been uploaded"),
                );
              }
            }return Scaffold(
                  body: Text("some thing went wrong"),
                );
          },
        ));
  }
  
}
