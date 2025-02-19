// To parse this JSON data, do
//
//     final stockSeriesMonthlyModel = stockSeriesMonthlyModelFromJson(jsonString);

import 'dart:convert';

StockSeriesMonthlyModel stockSeriesMonthlyModelFromJson(String str) =>
    StockSeriesMonthlyModel.fromJson(json.decode(str));

String stockSeriesMonthlyModelToJson(StockSeriesMonthlyModel data) =>
    json.encode(data.toJson());

class StockSeriesMonthlyModel {
  MetaData? metaData;
  Map<String, MonthlyTimeSery>? monthlyTimeSeries;

  StockSeriesMonthlyModel({
    this.metaData,
    this.monthlyTimeSeries,
  });

  factory StockSeriesMonthlyModel.fromJson(Map<String, dynamic> json) =>
      StockSeriesMonthlyModel(
        metaData: json["Meta Data"] == null
            ? null
            : MetaData.fromJson(json["Meta Data"]),
        monthlyTimeSeries: Map.from(json["Monthly Time Series"]!).map((k, v) =>
            MapEntry<String, MonthlyTimeSery>(k, MonthlyTimeSery.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "Meta Data": metaData?.toJson(),
        "Monthly Time Series": Map.from(monthlyTimeSeries!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class MetaData {
  String? the1Information;
  String? the2Symbol;
  DateTime? the3LastRefreshed;
  String? the4TimeZone;

  MetaData({
    this.the1Information,
    this.the2Symbol,
    this.the3LastRefreshed,
    this.the4TimeZone,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        the1Information: json["1. Information"],
        the2Symbol: json["2. Symbol"],
        the3LastRefreshed: json["3. Last Refreshed"] == null
            ? null
            : DateTime.parse(json["3. Last Refreshed"]),
        the4TimeZone: json["4. Time Zone"],
      );

  Map<String, dynamic> toJson() => {
        "1. Information": the1Information,
        "2. Symbol": the2Symbol,
        "3. Last Refreshed":
            "${the3LastRefreshed!.year.toString().padLeft(4, '0')}-${the3LastRefreshed!.month.toString().padLeft(2, '0')}-${the3LastRefreshed!.day.toString().padLeft(2, '0')}",
        "4. Time Zone": the4TimeZone,
      };
}

class MonthlyTimeSery {
  String? the1Open;
  String? the2High;
  String? the3Low;
  String? the4Close;
  String? the5Volume;

  MonthlyTimeSery({
    this.the1Open,
    this.the2High,
    this.the3Low,
    this.the4Close,
    this.the5Volume,
  });

  factory MonthlyTimeSery.fromJson(Map<String, dynamic> json) =>
      MonthlyTimeSery(
        the1Open: json["1. open"],
        the2High: json["2. high"],
        the3Low: json["3. low"],
        the4Close: json["4. close"],
        the5Volume: json["5. volume"],
      );

  Map<String, dynamic> toJson() => {
        "1. open": the1Open,
        "2. high": the2High,
        "3. low": the3Low,
        "4. close": the4Close,
        "5. volume": the5Volume,
      };
}
