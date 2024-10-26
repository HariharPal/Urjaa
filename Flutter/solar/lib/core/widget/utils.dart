import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solar/core/theme/app_pallete.dart';

enum ToastType { success, error, warning }

void showToast(
  BuildContext context, {
  required String content,
  ToastType type = ToastType.success,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Toast toastLength = Toast.LENGTH_SHORT,
}) {
  Color backgroundColor;
  Color textColor;

  // Set colors based on the toast type
  switch (type) {
    case ToastType.success:
      backgroundColor = Colors.lightGreen;
      textColor = Colors.white;
      break;
    case ToastType.error:
      backgroundColor = Colors.red;
      textColor = Colors.white;
      break;
    case ToastType.warning:
      backgroundColor = Colors.orange;
      textColor = Colors.black;
      break;
  }

  Fluttertoast.showToast(
    msg: content,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
}

class Loader extends StatelessWidget {
  Loader({super.key, this.color = Palette.smokeWhite});
  Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        color: color,
      ),
    );
  }
}
