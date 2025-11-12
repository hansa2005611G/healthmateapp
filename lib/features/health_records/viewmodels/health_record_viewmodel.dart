import 'package:flutter/foundation.dart';
import '../../../data/models/health_record_model.dart';
import '../../../data/database/database_helper.dart';
import '../../../core/utils/date_helper.dart';

/// Health Record ViewModel
/// Manages state and business logic for health records
class HealthRecordViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // ==================== STATE VARIABLES ====================

  // All records
  List<HealthRecord> _allRecords = [];
  List<HealthRecord> get allRecords => List.unmodifiable(_allRecords);

  // Filtered records (for search)
  List<HealthRecord> _filteredRecords = [];
  List<HealthRecord> get filteredRecords => List.unmodifiable(_filteredRecords);
  bool get hasActiveFilter => _filterDate != null;

  // Today's summary
  int _todaySteps = 0;
  int _todayCalories = 0;
  int _todayWater = 0;

  int get todaySteps => _todaySteps;
  int get todayCalories => _todayCalories;
  int get todayWater => _todayWater;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Filter state
  DateTime? _filterDate;
  DateTime? get filterDate => _filterDate;

  // Displayed records (either filtered or all)
  List<HealthRecord> get displayedRecords {
    return hasActiveFilter ? _filteredRecords : _allRecords;
  }

  // ==================== INITIALIZATION ====================

  HealthRecordViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadAllRecords();
    await loadTodaySummary();
  }

  // ==================== LOAD OPERATIONS ====================

  /// Load all health records from database
  Future<void> loadAllRecords() async {
    _setLoading(true);
    _clearError();

    try {
      _allRecords = await _dbHelper.getAllRecords();
      if (!hasActiveFilter) {
        _filteredRecords = _allRecords;
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load health records: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Load today's summary data
  Future<void> loadTodaySummary() async {
    try {
      final totals = await _dbHelper.getTodayTotals();
      _todaySteps = totals['steps'] ?? 0;
      _todayCalories = totals['calories'] ?? 0;
      _todayWater = totals['water'] ?? 0;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load today\'s summary: ${e.toString()}');
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await loadAllRecords();
    await loadTodaySummary();
  }

  // ==================== CREATE OPERATION ====================

  /// Add a new health record
  Future<bool> addRecord(HealthRecord record) async {
    _setLoading(true);
    _clearError();

    try {
      // Check if record already exists for this date
      final existingRecords = await _dbHelper.getRecordsByDate(record.date);
      if (existingRecords.isNotEmpty) {
        _setError('A record already exists for this date');
        return false;
      }

      // Insert record
      final id = await _dbHelper.insertRecord(record);

      if (id > 0) {
        // Reload data
        await refreshData();
        return true;
      } else {
        _setError('Failed to save health record');
        return false;
      }
    } catch (e) {
      _setError('Error saving record: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== UPDATE OPERATION ====================

  /// Update an existing health record
  Future<bool> updateRecord(HealthRecord record) async {
    _setLoading(true);
    _clearError();

    try {
      if (record.id == null) {
        _setError('Cannot update record without an ID');
        return false;
      }

      final rowsAffected = await _dbHelper.updateRecord(record);

      if (rowsAffected > 0) {
        // Reload data
        await refreshData();
        return true;
      } else {
        _setError('Failed to update health record');
        return false;
      }
    } catch (e) {
      _setError('Error updating record: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== DELETE OPERATION ====================

  /// Delete a health record
  Future<bool> deleteRecord(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final rowsAffected = await _dbHelper.deleteRecord(id);

      if (rowsAffected > 0) {
        // Reload data
        await refreshData();
        return true;
      } else {
        _setError('Failed to delete health record');
        return false;
      }
    } catch (e) {
      _setError('Error deleting record: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== SEARCH/FILTER OPERATIONS ====================

  /// Search records by date
  Future<void> searchByDate(DateTime date) async {
    _setLoading(true);
    _clearError();

    try {
      final dateString = DateHelper.toIsoString(date);
      _filteredRecords = await _dbHelper.getRecordsByDate(dateString);
      _filterDate = date;
      notifyListeners();
    } catch (e) {
      _setError('Failed to search records: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Clear search filter
  void clearSearch() {
    _filterDate = null;
    _filteredRecords = _allRecords;
    notifyListeners();
  }

  /// Get record by ID
  HealthRecord? getRecordById(int id) {
    try {
      return _allRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== ANALYTICS/STATISTICS ====================

  /// Get total steps for current month
  Future<int> getMonthlySteps() async {
    try {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final startDate = DateHelper.toIsoString(firstDay);
      final endDate = DateHelper.toIsoString(lastDay);

      return await _dbHelper.getTotalSteps(startDate, endDate);
    } catch (e) {
      return 0;
    }
  }

  /// Get average steps per day
  Future<double> getAverageSteps() async {
    try {
      return await _dbHelper.getAverageSteps();
    } catch (e) {
      return 0.0;
    }
  }

  /// Get record count
  int get recordCount => _allRecords.length;

  /// Check if there are any records
  bool get hasRecords => _allRecords.isNotEmpty;

  /// Check if there's data for today
  bool get hasTodayData =>
      _todaySteps > 0 || _todayCalories > 0 || _todayWater > 0;

  // ==================== STATE MANAGEMENT HELPERS ====================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear error message (call from UI)
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // ==================== VALIDATION ====================

  /// Validate if a date already has a record
  Future<bool> hasRecordForDate(String date) async {
    try {
      return await _dbHelper.recordExistsForDate(date);
    } catch (e) {
      return false;
    }
  }

  /// Check if a date can be used for new record
  Future<bool> canAddRecordForDate(String date, {int? excludeId}) async {
    try {
      final records = await _dbHelper.getRecordsByDate(date);
      if (records.isEmpty) return true;
      if (excludeId != null) {
        // When editing, check if the only existing record is the one being edited
        return records.length == 1 && records.first.id == excludeId;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== CLEANUP ====================

  @override
  void dispose() {
    // Close database connection if needed
    // _dbHelper.close(); // Uncomment if you want to close DB on dispose
    super.dispose();
  }
}