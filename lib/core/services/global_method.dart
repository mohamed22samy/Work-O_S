import 'package:flutter/material.dart';

import '../constant/constants.dart';

class GlobalMethods {
  static void showErroreDialog(
      {required String error, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Errore occured"),
            )
          ],
        ),
        content: Text(
          error,
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
              child: Text("Ok",
                  style: TextStyle(
                    color: Colors.pink.shade600,
                    fontSize: 20,
                  )))
        ],
      ),
    );
  }
}
