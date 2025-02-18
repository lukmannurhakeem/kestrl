import 'package:flutter/material.dart';
import '../model/stock_listing_model.dart';
import '../model/stock_search_result_model.dart';
import '../repositories/stock_repository.dart';

class StockProvider extends ChangeNotifier {
  final _stockRepo = StockRepository.instance;
  List<StockListingModel> _stocks = [];
  List<StockSearchResult> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  List<StockListingModel> get stocks => _stocks;
  List<StockSearchResult> get searchResults => _searchResults;
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

  Future<void> filterByExchange(String exchange) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stocks = await _stockRepo.getStockListingsByExchange(exchange);
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

      _searchResults = await _stockRepo.searchStocks(query);
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _isSearching = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
