import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

num margin_horizontal = 0.04;
num margin_vertical = 0.02;
double interline_padding = 5;

Color color_appbar = Colors.blue.shade600;
Color color_background = Colors.blue.shade300;
Color color_button = Color.fromARGB(255, 0, 101, 216);
Color color_notification_positive = Colors.green;
Color color_notification_negative = Colors.red;
Color color_text_button = Color.fromARGB(200, 255, 255, 255);
Color color_text_info = Colors.black;
Color color_text_appbar = Colors.black;

void snack(context, msg, color)
{
  showTopSnackBar(
    context,
    CustomSnackBar.info(
      message:
          msg,
      backgroundColor: color,
    ),
    animationDuration: Duration(milliseconds: 800),
    displayDuration: Duration(milliseconds: 600)
  );
}