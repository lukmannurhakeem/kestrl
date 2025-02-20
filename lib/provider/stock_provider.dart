import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/constant.dart';
import '../constants/local_db_constant.dart';
import '../model/stock_details_model.dart';
import '../model/stock_listing_model.dart';
import '../repositories/stock_repository.dart';
import '../widgets/common_widget.dart';

class StockProvider extends ChangeNotifier {
  final _stockRepo = StockRepository.instance;
  List<StockListingModel> _stocks = [];
  List<StockListingModel> _searchResults = [];
  List<StockListingModel> _watchList = [];
  Map<String, dynamic> _stockDetails = {};
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  List<StockListingModel> get stocks => _stocks;
  List<StockListingModel> get searchResults => _searchResults;
  List<StockListingModel> get watchList => _watchList;
  Map<String, dynamic> get stockDetails => _stockDetails;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> loadStocks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stocks = await _stockRepo.getStockListings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> searchStocks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      _searchQuery = query;
      notifyListeners();

      _searchResults = _stocks
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()) ||
                element.symbol.toLowerCase().contains(query.toLowerCase()) ||
                element.name.toLowerCase() == query.toLowerCase() ||
                element.symbol.toLowerCase() == query.toLowerCase(),
          )
          .toList();
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addToWatchlist(String keyword) async {
    try {
      bool exists = _watchList.any((element) => element.name == keyword);
      if (exists) {
        throw Exception('Stock is already in the watchlist');
      }

      final stocksToAdd =
          _stocks.where((element) => element.name == keyword).toList();
      if (stocksToAdd.isEmpty) {
        throw Exception('Stock not found');
      }

      _watchList.addAll(stocksToAdd);

      await saveWatchlistToStorage();

      snackBarSuccess(content: 'Successfully added to watchlist');
    } catch (e) {
      snackBarFailed(content: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveWatchlistToStorage() async {
    try {
      final box = Hive.box(ConstantValue.dbName);

      final List<String> jsonStringList =
          _watchList.map((stock) => json.encode(stock.toJson())).toList();

      await box.put(DBConstant.KEY_WATCHLIST, jsonStringList);
      print('Saving watchlist to storage');
    } catch (e) {
      print('Error saving watchlist to storage: $e');
      throw Exception('Failed to save watchlist: ${e.toString()}');
    }
  }

  Future<void> removeFromWatchlist(String keyword) async {
    try {
      _watchList.removeWhere((element) => element.name == keyword);

      await saveWatchlistToStorage();

      snackBarSuccess(content: 'Successfully removed from watchlist');
    } catch (e) {
      snackBarFailed(content: 'Error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWatchlistFromStorage() async {
    try {
      _isLoading = true;
      notifyListeners();

      final box = Hive.box(ConstantValue.dbName);
      final List<dynamic>? storedWatchlist = box.get(DBConstant.KEY_WATCHLIST);

      if (storedWatchlist != null) {
        _watchList = storedWatchlist.map<StockListingModel>((item) {
          final Map<String, dynamic> jsonMap = json.decode(item);
          return StockListingModel.fromJson(jsonMap);
        }).toList();
      }
    } catch (e) {
      print('Error loading watchlist from storage: $e');
      snackBarFailed(content: 'Error loading watchlist: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStockDetails(String keyword) async {
    try {
      _isLoading = true;
      notifyListeners();

      _stockDetails = await StockRepository.instance.viewStockDetails(keyword);
    } catch (e) {
      snackBarFailed(
          content: 'Error loading saved activities: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTimeSeriesMonthly(String keyword) async {
    try {
      _isLoading = true;
      notifyListeners();

      await StockRepository.instance.getSeriesMonthly(keyword);
    } catch (e) {
      snackBarFailed(
          content: 'Error loading saved activities: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
