import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constant.dart';
import '../constants/local_db_constant.dart';
import 'locator_service.dart';

class LocalDBService {
  static LocalDBService get instance => locator<LocalDBService>();

  Future<LocalDBService> initService() async {
    final Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);

    await Hive.openBox(ConstantValue.dbName);
    await Hive.openBox(ConstantValue.sysDbName);

    if (Hive.box(ConstantValue.dbName).isEmpty) {
      Hive.box(ConstantValue.dbName).put(DBConstant.KEY_IS_FIRST_TIME, true);
      Hive.box(ConstantValue.dbName).put(DBConstant.KEY_IS_LOGGED_IN, false);
    }
    log('xxxx LOCAL DB INITIALIZED');
    return this;
  }

  Future<void> setIsLoggedIn(bool val) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_IS_LOGGED_IN, val);
  }

  Future<void> setUsername(String val) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_USERNAME, val);
  }

  Future<void> setEmail(String val) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_EMAIL, val);
  }

  Future<void> setUid(String val) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_UID, val);
  }

  Future<void> setLocale(String val) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_LANGUAGE, val);
  }

  Future<void> setGoogleDirectionAPI(String? val) async {
    await Hive.box(ConstantValue.dbName)
        .put(DBConstant.KEY_GOOGLE_DIRECTION_API, val);
  }

  String getToken() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_TOKEN, defaultValue: '');
  }

  String getRefreshToken() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_REFRESH_TOKEN, defaultValue: '');
  }

  String getUsername() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_USERNAME, defaultValue: '');
  }

  String getEmail() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_EMAIL, defaultValue: '');
  }

  String getUid() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_UID, defaultValue: '5ad701ef4cedfd0001022276');
  }

  String getLocale() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_LANGUAGE, defaultValue: 'en');
  }

  bool isLoggedIn() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.KEY_IS_LOGGED_IN, defaultValue: false);
  }

  Future<void> setToken(String token) async {
    await Hive.box(ConstantValue.dbName).put(DBConstant.KEY_TOKEN, token);
  }

  Future<void> setRefreshToken(String token) async {
    await Hive.box(ConstantValue.dbName)
        .put(DBConstant.KEY_REFRESH_TOKEN, token);
  }

  void setIs24Hours(bool val) {
    Hive.box(ConstantValue.dbName).put(DBConstant.IS_24_HOURS, val);
    return;
  }

  bool getIs24Hours() {
    return Hive.box(ConstantValue.dbName)
        .get(DBConstant.IS_24_HOURS, defaultValue: false);
  }

  // Updated method to store list of ActivityModel objects
  // Future<void> setHistory(List<ActivityModel>? activities) async {
  //   if (activities == null) {
  //     await Hive.box(ConstantValue.dbName).delete(DBConstant.KEY_LIST);
  //     return;
  //   }

  //   // Convert the list to a list of JSON maps
  //   final List<String> jsonStringList =
  //       activities.map((activity) => json.encode(activity.toJson())).toList();

  //   // Store the JSON string list
  //   await Hive.box(ConstantValue.dbName)
  //       .put(DBConstant.KEY_LIST, jsonStringList);
  // }

  // Updated method to retrieve list of ActivityModel objects
  // List<ActivityModel>? getHistory() {
  //   final List<dynamic>? jsonStringList =
  //       Hive.box(ConstantValue.dbName).get(DBConstant.KEY_LIST);

  //   if (jsonStringList == null) return null;

  //   try {
  //     // Convert the JSON string list back to ActivityModel objects
  //     return jsonStringList.map<ActivityModel>((jsonString) {
  //       final Map<String, dynamic> jsonMap = json.decode(jsonString);
  //       return ActivityModel.fromJson(jsonMap);
  //     }).toList();
  //   } catch (e) {
  //     log('Error parsing activity history: $e');
  //     return null;
  //   }
  // }

  Future<void> setSelectedTypes(String types) async {
    if (types.isEmpty) {
      await Hive.box(ConstantValue.dbName)
          .delete(DBConstant.KEY_SELECTED_TYPES);
      return;
    }

    await Hive.box(ConstantValue.dbName)
        .put(DBConstant.KEY_SELECTED_TYPES, types);
  }

  String? getSelectedTypes() {
    print('Henlo 3');

    final String? storedTypes =
        Hive.box(ConstantValue.dbName).get(DBConstant.KEY_SELECTED_TYPES);
    print('Store $storedTypes');
    if (storedTypes == null) return null;

    return storedTypes;
  }

  Future<void> clearDB() async {
    await Hive.box(ConstantValue.dbName).clear();
  }
}
