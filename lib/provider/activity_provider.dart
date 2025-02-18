import 'package:flutter/material.dart';
import '../repositories/stock_repository.dart';
import '../services/local_db_service.dart';
import '../services/locator_service.dart';
import '../widgets/common_widget.dart';

class ActivityProvider extends ChangeNotifier {
  bool isLoading = false;
  final LocalDBService _localDbService = locator<LocalDBService>();

  final List<String> preferType = [
    'education',
    'recreational',
    'social',
    'charity',
    'cooking',
    'relaxation',
    'music',
    'busywork'
  ];

  String _selectedTypes = '';
  String get selectedTypes => _selectedTypes;

  ActivityProvider() {
    // Initial loading is still done in constructor
    loadSavedActivities();
  }

  Future<void> loadSavedActivities() async {
    try {
      isLoading = true;
      notifyListeners();

      final stockListing = await StockRepository.instance.getStockListings();
    } catch (e) {
      snackBarFailed(
          content: 'Error loading saved activities: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
