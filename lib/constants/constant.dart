import 'package:flutter/material.dart';

import '../services/dialog_services.dart';
import '../services/navigation_service.dart';

const String stgUrl = 'https://www.alphavantage.co';
// ADD YOUR KEY HERE
const String apiKey = 'Your key';

class ConstantValue {
  static const String dbName = 'localDB';
  static const String sysDbName = 'SysLocalDB';
  // static String googleMapKey = LocalDBService.instance.getGoogleDirectionAPIKey();
  static double textBoldSizeGlobal = 15;
  static double textPrimarySizeGlobal = 14;
  static double textSecondarySizeGlobal = 14;
  static String? fontFamilyBoldGlobal;
  static String? fontFamilyPrimaryGlobal;
  static String? fontFamilySecondaryGlobal;
  static FontWeight fontWeightBoldGlobal = FontWeight.bold;
  static FontWeight fontWeightPrimaryGlobal = FontWeight.normal;
  static FontWeight fontWeightSecondaryGlobal = FontWeight.normal;
  static Color? defaultInkWellSplashColor;
  static Color? defaultInkWellHoverColor;
  static Color? defaultInkWellHighlightColor;
  static double? defaultInkWellRadius;

  static Color shadowColorGlobal = Colors.grey.withOpacity(0.2);
  static double defaultRadius = 8.0;
  static double defaultBlurRadius = 4.0;
  static double defaultSpreadRadius = 1.0;
  static int passwordLengthGlobal = 8;
  static int maximumPasswordLength = 16;
}

//loading
void showLoading() {
  DialogService.showAnyDialog(
    barrierDismissible: false,
    dialog: const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
            child: SizedBox(
                height: 150,
                width: 150,
                child: Center(child: CircularProgressIndicator()))),
      ],
    ),
  );
}

void closeLoading() {
  NavigationService.instance.pop();
}
