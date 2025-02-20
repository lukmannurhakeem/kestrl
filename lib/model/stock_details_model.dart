// stock_detail_model.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class StockDetailModel extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? industry;

  @HiveField(3)
  final String? sector;

  @HiveField(4)
  final String? exchange;

  @HiveField(5)
  final String? marketCap;

  @HiveField(6)
  final String? peRatio;

  @HiveField(7)
  final String? dividendYield;

  @HiveField(8)
  final String? weekHigh52;

  @HiveField(9)
  final String? weekLow52;

  @HiveField(10)
  final String? eps;

  @HiveField(11)
  final String? description;

  @HiveField(12)
  final DateTime lastUpdated;

  StockDetailModel({
    required this.symbol,
    required this.name,
    this.industry,
    this.sector,
    this.exchange,
    this.marketCap,
    this.peRatio,
    this.dividendYield,
    this.weekHigh52,
    this.weekLow52,
    this.eps,
    this.description,
    required this.lastUpdated,
  });

  factory StockDetailModel.fromJson(Map<String, dynamic> json) {
    return StockDetailModel(
      symbol: json['Symbol'] ?? '',
      name: json['Name'] ?? '',
      industry: json['Industry'],
      sector: json['Sector'],
      exchange: json['Exchange'],
      marketCap: json['MarketCapitalization'],
      peRatio: json['PERatio'],
      dividendYield: json['DividendYield'],
      weekHigh52: json['52WeekHigh'],
      weekLow52: json['52WeekLow'],
      eps: json['EPS'],
      description: json['Description'],
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Symbol': symbol,
      'Name': name,
      'Industry': industry,
      'Sector': sector,
      'Exchange': exchange,
      'MarketCapitalization': marketCap,
      'PERatio': peRatio,
      'DividendYield': dividendYield,
      '52WeekHigh': weekHigh52,
      '52WeekLow': weekLow52,
      'EPS': eps,
      'Description': description,
    };
  }
}
