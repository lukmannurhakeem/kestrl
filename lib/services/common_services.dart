import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../routes/routes_path.dart';
import 'local_db_service.dart';
import 'navigation_service.dart';

const platform = MethodChannel('DBS');

class CommonService {
  static Future<void> goNextScreen() async {
    Future.delayed(const Duration(seconds: 2), () {
      if (LocalDBService.instance.isLoggedIn()) {
        NavigationService.instance.pushNamedAndRemoveUntil(Routes.HISTORY);
      } else {
        NavigationService.instance.pushNamedAndRemoveUntil(Routes.LOGIN);
      }
      //  NavigationService.instance.pushNamedAndRemoveUntil(Routes.LOGIN);
    });
  }

  static Future<String?> encrypt(String plainText) async {
    try {
      final String encryptedText =
          await platform.invokeMethod('encrypt', {'plainText': plainText});

      if (Platform.isAndroid) {
        log('xxxx android: $encryptedText');
      } else {
        log('xxxx ios: $encryptedText');
      }
      return encryptedText;
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print("Error: ${e.message}");
      return null;
    }
  }

  static Future<String?> getMemberIDFromSDK() async {
    try {
      final String memberID = await platform.invokeMethod('member_id');
      return memberID;
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print("Error: ${e.message}");
      return null;
    }
  }

  static Future<String?> getAccessTokenFromSDK() async {
    try {
      final String accessToken = await platform.invokeMethod('access_token');
      return accessToken;
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print("Error: ${e.message}");
      return null;
    }
  }

  static changeStatusBarIconColor({required bool isDark}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static bool isDarkColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light ||
            color == Colors.transparent
        ? false
        : true;
  }
}
