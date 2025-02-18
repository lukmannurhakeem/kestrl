import 'package:flutter/material.dart';

import '../model/activity_model.dart';
import '../repositories/activity_repo.dart';
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

  List<ActivityModel>? _list = [];
  List<ActivityModel>? get list => _list;

  String _selectedTypes = '';
  String get selectedTypes => _selectedTypes;

  ActivityModel? activityModel;

  ActivityProvider() {
    // Initial loading is still done in constructor
    loadSavedActivities();
  }

  // Public method to load activities from local storage
  Future<void> loadSavedActivities() async {
    try {
      isLoading = true;
      notifyListeners();

      final savedActivities = _localDbService.getHistory();
      if (savedActivities != null && savedActivities.isNotEmpty) {
        _list = savedActivities;
      }
    } catch (e) {
      snackBarFailed(
          content: 'Error loading saved activities: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedActivitiesByTypes(String type) async {
    try {
      isLoading = true;
      notifyListeners();

      final savedActivities = _localDbService.getHistory();
      if (savedActivities != null && savedActivities.isNotEmpty) {
        _list = savedActivities
            .where(
                (element) => element.type!.toLowerCase() == type.toLowerCase())
            .toList();
      }
    } catch (e) {
      snackBarFailed(
          content: 'Error loading saved activities: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Save activities to local storage
  Future<void> _saveActivities() async {
    try {
      await _localDbService.setHistory(_list);
    } catch (e) {
      snackBarFailed(content: 'Error saving activities: ${e.toString()}');
    }
  }

  // Fetch a new activity and add it to the list
  Future<void> fetchActivity() async {
    try {
      isLoading = true;
      notifyListeners();

      activityModel = await ActivityRepository.instance.getActivityModel();

      if (activityModel != null) {
        if (_list == null) _list = [];
        _list!.add(activityModel!);

        // Save updated list to local storage
        await _saveActivities();
      }
    } catch (e) {
      snackBarFailed(content: e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a new activity by type and add it to the list
  Future<void> fetchActivityByType(String type) async {
    try {
      isLoading = true;
      notifyListeners();

      activityModel = await ActivityRepository.instance
          .getActivityModelByType(type.toLowerCase());

      if (activityModel != null) {
        if (_list == null) _list = [];
        _list!.add(activityModel!);

        // Save updated list to local storage
        await _saveActivities();
      }
    } catch (e) {
      snackBarFailed(content: e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear all activities
  Future<void> clearActivities() async {
    try {
      isLoading = true;
      notifyListeners();

      _list = [];
      await _saveActivities();
    } catch (e) {
      snackBarFailed(content: 'Error clearing activities: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Remove a specific activity
  Future<void> removeActivity(ActivityModel activity) async {
    try {
      if (_list != null && _list!.contains(activity)) {
        _list!.remove(activity);
        await _saveActivities();
        notifyListeners();
      }
    } catch (e) {
      snackBarFailed(content: 'Error removing activity: ${e.toString()}');
    }
  }

  void updateSelectedTypes(String types) {
    _selectedTypes = types;
    _saveSelectedTypes();
    notifyListeners();
  }

  // Save selected types to local storage
  Future<void> _saveSelectedTypes() async {
    try {
      await _localDbService.setSelectedTypes(_selectedTypes);
    } catch (e) {
      snackBarFailed(content: 'Error saving selected types: ${e.toString()}');
    }
  }

  Future<String> getSaveSelectedTypes() async {
    try {
      print('Henlo 2');
      _selectedTypes = _localDbService.getSelectedTypes() ?? '';
    } catch (e) {
      snackBarFailed(content: 'Error saving selected types: ${e.toString()}');
    }
    return _selectedTypes;
  }
}
