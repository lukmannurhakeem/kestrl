import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../constants/constant.dart';
import '../constants/endpoints_constant.dart';
import '../constants/local_db_constant.dart';
import '../model/stock_listing_model.dart';
import '../model/stock_search_result_model.dart';
import '../model/stock_series_monthly_model.dart';
import '../services/http_service.dart';
import '../services/local_db_service.dart';
import '../services/locator_service.dart';
import '../widgets/common_widget.dart';

class StockRepository {
  static StockRepository get instance => locator<StockRepository>();
  static final serviceLocalDb = locator<LocalDBService>();

  Future<List<StockListingModel>> getStockListings() async {
    try {
      Response response = await APIService.instance.get(
        {},
        endpoint: EndpointConstant.stockListing,
      );

      // response.data is already a String containing CSV data
      final listings = stockListingModelFromCsv(response.data);

      await setStockListings(listings);

      return listings;
    } catch (e, st) {
      print(e.toString());
      print(st);
      return getStoredStockListings() ?? [];
    }
  }

  List<StockListingModel>? getStoredStockListings() {
    try {
      final List<dynamic>? jsonStringList =
          Hive.box(ConstantValue.dbName).get(DBConstant.KEY_STOCK_LISTINGS);

      if (jsonStringList == null) return null;

      // Convert JSON strings back to StockListingModel objects
      return jsonStringList.map<StockListingModel>((jsonString) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return StockListingModel.fromJson(jsonMap);
      }).toList();
    } catch (e) {
      print('Error retrieving stock listings from Hive: ${e.toString()}');
      return null;
    }
  }

  Future<void> setStockListings(List<StockListingModel>? listings) async {
    try {
      if (listings == null) {
        await Hive.box(ConstantValue.dbName)
            .delete(DBConstant.KEY_STOCK_LISTINGS);
        return;
      }

      // Convert the list to JSON strings
      final List<String> jsonStringList =
          listings.map((listing) => json.encode(listing.toJson())).toList();

      // Store in Hive
      await Hive.box(ConstantValue.dbName)
          .put(DBConstant.KEY_STOCK_LISTINGS, jsonStringList);

      print('Saved ${listings.length} stock listings to Hive');
    } catch (e, st) {
      print('Error saving stock listings to Hive: ${e.toString()}');
      print(st);
      rethrow;
    }
  }

  Future<void> clearStockListings() async {
    try {
      await Hive.box(ConstantValue.dbName)
          .delete(DBConstant.KEY_STOCK_LISTINGS);
    } catch (e) {
      print('Error clearing stock listings: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<StockListingModel>> getStockListingsByExchange(
      String exchange) async {
    try {
      final listings = await getStockListings();
      return listings
          .where(
              (stock) => stock.exchange.toLowerCase() == exchange.toLowerCase())
          .toList();
    } catch (e, st) {
      print(e.toString());
      print(st);
      rethrow;
    }
  }

  Future<List<StockSearchResult>> searchStocks(String query) async {
    try {
      Response response = await APIService.instance.get(
        {},
        fullUrl: 'https://www.alphavantage.co/query',
        parameters: {
          'function': 'SYMBOL_SEARCH',
          'keywords': query,
          'apikey': '$apiKey',
          'datatype': 'csv'
        },
      );

      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('Information')) {
        String infoMessage = response.data['Information'];
        snackBarFailed(content: infoMessage);
      }

      return stockSearchFromCsv(response.data);
    } catch (e, st) {
      print(e.toString());
      print(st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> viewStockDetails(String symbol) async {
    try {
      Response response = await APIService.instance.get(
        {},
        fullUrl: 'https://www.alphavantage.co/query',
        parameters: {
          'function': 'OVERVIEW',
          'symbol': symbol,
          'apikey': '$apiKey',
        },
      );
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('Information')) {
        String infoMessage = response.data['Information'];
        snackBarFailed(content: infoMessage);
      }

      return response.data;
    } catch (e, st) {
      print(e.toString());
      print(st);
      rethrow;
    }
  }

  Future<StockSeriesMonthlyModel> getSeriesMonthly(String symbol) async {
    try {
      Response response = await APIService.instance.get(
        {},
        fullUrl: 'https://www.alphavantage.co/query',
        parameters: {
          'function': 'TIME_SERIES_MONTHLY',
          'symbol': symbol,
          'apikey': '$apiKey',
        },
      );

      return stockSeriesMonthlyModelFromJson(response.data);
    } catch (e, st) {
      print(e.toString());
      print(st);
      rethrow;
    }
  }
}
