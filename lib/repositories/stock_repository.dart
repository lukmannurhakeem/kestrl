import 'dart:convert';

import 'package:dio/dio.dart';
import '../constants/constant.dart';
import '../constants/endpoints_constant.dart';
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
      return listings;
    } catch (e, st) {
      print(e.toString());
      print(st);
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
          // 'apikey': '7SVSXP9IBZ4BOB8R',
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
          // 'apikey': '7SVSXP9IBZ4BOB8R',
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
          // 'apikey': '7SVSXP9IBZ4BOB8R',
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
