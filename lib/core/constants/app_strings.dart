/// App-wide string constants for consistent text throughout the app
/// Helps with maintainability and potential future localization
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // ==================== APP GENERAL ====================
  
  static const String appName = 'HealthMate';
  static const String appTagline = 'Your Personal Health Tracker';

  // ==================== SCREEN TITLES ====================
  
  static const String dashboardTitle = 'Dashboard';
  static const String addRecordTitle = 'Add Health Entry';
  static const String editRecordTitle = 'Edit Health Entry';
  static const String recordsListTitle = 'Health Records';

  // ==================== NAVIGATION ====================
  
  static const String navDashboard = 'Dashboard';
  static const String navAddEntry = 'Add Entry';
  static const String navRecords = 'Records';

  // ==================== HEALTH METRICS ====================
  
  static const String stepsLabel = 'Steps';
  static const String caloriesLabel = 'Calories';
  static const String waterLabel = 'Water';
  
  static const String stepsUnit = 'steps';
  static const String caloriesUnit = 'kcal';
  static const String waterUnit = 'ml';
  
  static const String stepsHint = 'Enter steps walked';
  static const String caloriesHint = 'Enter calories burned';
  static const String waterHint = 'Enter water intake';

  // ==================== FORM LABELS ====================
  
  static const String dateLabel = 'Date';
  static const String selectDate = 'Select Date';
  static const String dateHint = 'Choose entry date';

  // ==================== BUTTONS ====================
  
  static const String saveButton = 'Save Record';
  static const String updateButton = 'Update Record';
  static const String deleteButton = 'Delete';
  static const String cancelButton = 'Cancel';
  static const String editButton = 'Edit';
  static const String confirmButton = 'Confirm';
  static const String addButton = 'Add';
  static const String viewAllButton = 'View All Records';
  static const String searchButton = 'Search';
  static const String clearButton = 'Clear';
  static const String addFirstEntryButton = 'Add First Entry';

  // ==================== DASHBOARD ====================
  
  static const String todaySummary = 'Today\'s Summary';
  static const String noDashboardData = 'No data recorded for today';
  static const String startTracking = 'Start tracking your health!';
  static const String tapToAddEntry = 'Tap the + button to add your first entry';

  // ==================== RECORDS LIST ====================
  
  static const String noRecordsFound = 'No records found';
  static const String noRecordsMessage = 'Start adding health entries to track your progress';
  static const String searchByDate = 'Search by date';
  static const String filterByDate = 'Filter by date';
  static const String clearFilter = 'Clear filter';
  static const String showingRecordsFor = 'Showing records for';
  static const String allRecords = 'All Records';

  // ==================== VALIDATION MESSAGES ====================
  
  static const String fieldRequired = 'This field is required';
  static const String invalidNumber = 'Please enter a valid number';
  static const String valueTooLow = 'Value must be greater than 0';
  static const String valueTooHigh = 'Value is too high';
  
  static const String stepsValidation = 'Steps must be between 0 and 50,000';
  static const String caloriesValidation = 'Calories must be between 0 and 10,000';
  static const String waterValidation = 'Water must be between 0 and 10,000 ml';

  // ==================== SUCCESS MESSAGES ====================
  
  static const String recordAdded = 'Health record added successfully';
  static const String recordUpdated = 'Health record updated successfully';
  static const String recordDeleted = 'Health record deleted successfully';

  // ==================== ERROR MESSAGES ====================
  
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorLoadingRecords = 'Failed to load health records';
  static const String errorSavingRecord = 'Failed to save health record';
  static const String errorUpdatingRecord = 'Failed to update health record';
  static const String errorDeletingRecord = 'Failed to delete health record';
  static const String errorDatabaseInit = 'Failed to initialize database';
  static const String errorNoInternet = 'No internet connection';
  static const String duplicateRecordError = 'A record already exists for this date';

  // ==================== CONFIRMATION DIALOGS ====================
  
  static const String deleteConfirmTitle = 'Delete Record?';
  static const String deleteConfirmMessage = 'This action cannot be undone. Are you sure you want to delete this health record?';
  
  static const String unsavedChangesTitle = 'Unsaved Changes';
  static const String unsavedChangesMessage = 'You have unsaved changes. Do you want to discard them?';
  static const String discardButton = 'Discard';
  static const String keepEditingButton = 'Keep Editing';
  
  static const String exitAppTitle = 'Exit HealthMate?';
  static const String exitAppMessage = 'Are you sure you want to exit?';
  static const String exitButton = 'Exit';
  static const String stayButton = 'Stay';

  // ==================== LOADING STATES ====================
  
  static const String loading = 'Loading...';
  static const String loadingRecords = 'Loading health records...';
  static const String saving = 'Saving...';
  static const String updating = 'Updating...';
  static const String deleting = 'Deleting...';

  // ==================== EMPTY STATES ====================
  
  static const String emptyDashboard = 'No data for today';
  static const String emptyDashboardSubtitle = 'Add your first health entry to see your daily summary';
  static const String emptyRecordsList = 'No health records yet';
  static const String emptyRecordsSubtitle = 'Start tracking your health journey today!';
  static const String emptySearchResults = 'No records found for this date';
  static const String emptySearchSubtitle = 'Try selecting a different date';

  // ==================== HELPER METHODS ====================
  
  /// Get formatted metric name with unit
  static String getMetricWithUnit(String metric) {
    switch (metric.toLowerCase()) {
      case 'steps':
        return '$stepsLabel ($stepsUnit)';
      case 'calories':
        return '$caloriesLabel ($caloriesUnit)';
      case 'water':
        return '$waterLabel ($waterUnit)';
      default:
        return metric;
    }
  }
  
  /// Get validation message for specific metric
  static String getMetricValidation(String metric) {
    switch (metric.toLowerCase()) {
      case 'steps':
        return stepsValidation;
      case 'calories':
        return caloriesValidation;
      case 'water':
        return waterValidation;
      default:
        return fieldRequired;
    }
  }
}