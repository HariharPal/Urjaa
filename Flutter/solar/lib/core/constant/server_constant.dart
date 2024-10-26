import 'dart:io';

import 'package:flutter/material.dart';

class ServerConstants {
  static String serverUrl =
      Platform.isAndroid ? "http://172.16.5.15:8000" : "http://127.0.0.1:8000";

  double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
