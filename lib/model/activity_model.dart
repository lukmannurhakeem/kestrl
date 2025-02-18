// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';

ActivityModel activityModelFromJson(String str) => ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  String? activity;
  String? type;
  int? participants;
  double? price;
  String? link;
  String? key;
  double? accessibility;

  ActivityModel({
    this.activity,
    this.type,
    this.participants,
    this.price,
    this.link,
    this.key,
    this.accessibility,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        activity: json["activity"],
        type: json["type"],
        participants: json["participants"],
        price: json["price"]?.toDouble(),
        link: json["link"],
        key: json["key"],
        accessibility: json["accessibility"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "activity": activity,
        "type": type,
        "participants": participants,
        "price": price,
        "link": link,
        "key": key,
        "accessibility": accessibility,
      };
}
