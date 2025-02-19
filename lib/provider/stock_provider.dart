import 'package:flutter/material.dart';
import '../model/stock_listing_model.dart';
import '../repositories/stock_repository.dart';
import '../widgets/common_widget.dart';

class StockProvider extends ChangeNotifier {
  final _stockRepo = StockRepository.instance;
  List<StockListingModel> _stocks = [];
  List<StockListingModel> _searchResults = [];
  Map<String, dynamic> _stockDetails = {};
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  List<StockListingModel> get stocks => _stocks;
  List<StockListingModel> get searchResults => _searchResults;
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

  Future<void> loadStockDetails(String keyword) async {
    print('Hello');
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
