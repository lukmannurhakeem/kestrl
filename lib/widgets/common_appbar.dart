import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/color_constant.dart';
import '../constants/widget_extensions.dart';
import '../extensions/text_style_extensions.dart';
import '../services/common_services.dart';
import '../services/navigation_service.dart';

PreferredSizeWidget CommonAppBar(
    {required BuildContext context,
    required String title,
    final Color? bgColor,
    final double? elevation,
    final Color? textColor,
    final bool? hasBackButton,
    final VoidCallback? backButtonCallback,
    final action}) {
  double _height = MediaQuery.of(context).size.height;
  return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness:
            CommonService.isDarkColor(bgColor ?? ColorConstant.mainColor)
                ? Brightness.light
                : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness:
            CommonService.isDarkColor(bgColor ?? ColorConstant.white)
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            CommonService.isDarkColor(bgColor ?? ColorConstant.white)
                ? Brightness.light
                : Brightness.dark,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.titleS!.copyWith(
                color: textColor ?? ColorConstant.primaryColor, fontSize: 17),
          ),
          // Text(
          //   'SettlePayz',
          //   style: context.textTheme.headline6!.copyWith(
          //       color: textColor ?? Colors.grey[300], fontSize: 10),
          // ),
        ],
      ),
      centerTitle: true,
      backgroundColor: bgColor ?? ColorConstant.white,
      elevation: elevation ?? 0,
      shadowColor: Colors.grey[300],
      leading: hasBackButton == null
          ? Icon(
              FontAwesomeIcons.chevronLeft,
              color: textColor ?? ColorConstant.primaryColor,
              size: 20,
            ).onTap(
              backButtonCallback ?? () => NavigationService.instance.pop())
          : hasBackButton
              ? Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: textColor ?? ColorConstant.primaryColor,
                  size: 20,
                ).onTap(
                  backButtonCallback ?? () => NavigationService.instance.pop())
              : Container(),
      actions: action);
}
