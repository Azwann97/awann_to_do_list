import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToDoListNavigator {
  //Awann - 26 Dec 2022
  //global custom page navigator
  navigateTo({required String path, required BuildContext context}) {
    if (path == "/") {
      Navigator.of(context).pushNamedAndRemoveUntil(path, (route) => false);
    } else {
      Navigator.of(context).pushNamed(path);
    }
  }
}
