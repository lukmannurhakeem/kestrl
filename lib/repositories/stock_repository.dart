import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/endpoints_constant.dart';
import '../model/stock_listing_model.dart';
import '../model/stock_search_result_model.dart';
import '../services/http_service.dart';
import '../services/local_db_service.dart';
import '../services/locator_service.dart';

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
          'apikey': '7SVSXP9IBZ4BOB8R',
          'datatype': 'csv'
        },
      );

      return stockSearchFromCsv(response.data);
    } catch (e, st) {
      print(e.toString());
      print(st);
      rethrow;
    }
  }
}
