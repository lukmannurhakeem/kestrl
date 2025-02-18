import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/color_constant.dart';
import '../constants/string_extensions.dart';
import '../extensions/int_extensions.dart';
import '../extensions/text_style_extensions.dart';
import '../services/navigation_service.dart';

Widget reusableDivider({double? height}) =>
    Divider(height: height ?? 0, thickness: 0.5);

bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

void toast(
  String? value, {
  ToastGravity? gravity,
  length = Toast.LENGTH_SHORT,
  Color? bgColor,
  Color? textColor,
}) {
  if (value.validate().isEmpty) {
    print(value);
  } else {
    Fluttertoast.showToast(
      msg: value.validate(),
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }
}

/// Show SnackBar
void snackBar(
  BuildContext context, {
  String title = '',
  Widget? content,
  SnackBarAction? snackBarAction,
  Function? onVisible,
  Color? textColor,
  Color? backgroundColor,
  EdgeInsets? margin,
  EdgeInsets? padding,
  Animation<double>? animation,
  double? width,
  ShapeBorder? shape,
  Duration? duration,
  SnackBarBehavior? behavior,
  double? elevation,
}) {
  if (title.isEmpty && content != null) {
    debugPrint('SnackBar message is empty');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        action: snackBarAction,
        margin: margin,
        animation: animation,
        width: width,
        shape: shape,
        duration: 4.seconds,
        behavior: margin != null ? SnackBarBehavior.floating : behavior,
        elevation: elevation,
        onVisible: onVisible?.call(),
        content: content ??
            Padding(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                title,
                style: primaryTextStyle(color: textColor ?? Colors.white),
              ),
            ),
      ),
    );
  }
}

void snackBarFailed({required String content}) => snackBar(
      NavigationService.instance.navigatorKey.currentState!.context,
      title: content,
      backgroundColor: ColorConstant.primaryColor,
      textColor: Colors.white,
    );

void snackBarSuccess({
  required String content,
  Color? backgroundColor,
  Color? textColor,
}) =>
    snackBar(
      NavigationService.instance.navigatorKey.currentState!.context,
      title: content,
      backgroundColor: backgroundColor ?? Colors.green,
      textColor: textColor ?? Colors.white,
    );

Widget centerLoading() => const Center(child: CircularProgressIndicator());
