/// App-wide dimension constants for consistent spacing, sizing, and layout
/// Follows a consistent spacing system (4dp base unit)
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // ==================== SPACING SYSTEM (4dp base) ====================
  
  /// Extra extra small spacing - 4dp
  static const double spacingXXS = 4.0;
  
  /// Extra small spacing - 8dp
  static const double spacingXS = 8.0;
  
  /// Small spacing - 12dp
  static const double spacingS = 12.0;
  
  /// Medium spacing - 16dp (default/most common)
  static const double spacingM = 16.0;
  
  /// Large spacing - 24dp
  static const double spacingL = 24.0;
  
  /// Extra large spacing - 32dp
  static const double spacingXL = 32.0;
  
  /// Extra extra large spacing - 48dp
  static const double spacingXXL = 48.0;

  // ==================== PADDING ====================
  
  /// Screen edge padding
  static const double screenPadding = 16.0;
  
  /// Card padding
  static const double cardPadding = 16.0;
  
  /// List item padding
  static const double listItemPadding = 12.0;
  
  /// Button padding horizontal
  static const double buttonPaddingH = 24.0;
  
  /// Button padding vertical
  static const double buttonPaddingV = 12.0;
  
  /// Input field padding
  static const double inputPadding = 16.0;

  // ==================== BORDER RADIUS ====================
  
  /// Small border radius - 4dp
  static const double radiusS = 4.0;
  
  /// Medium border radius - 8dp
  static const double radiusM = 8.0;
  
  /// Large border radius - 12dp
  static const double radiusL = 12.0;
  
  /// Extra large border radius - 16dp
  static const double radiusXL = 16.0;
  
  /// Circular border radius - 999dp
  static const double radiusCircular = 999.0;
  
  /// Card border radius
  static const double cardRadius = 12.0;
  
  /// Button border radius
  static const double buttonRadius = 8.0;
  
  /// Input field border radius
  static const double inputRadius = 8.0;
  
  /// Dialog border radius
  static const double dialogRadius = 16.0;

  // ==================== ELEVATION / SHADOW ====================
  
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Low elevation (cards at rest)
  static const double elevationLow = 2.0;
  
  /// Medium elevation (raised cards)
  static const double elevationMedium = 4.0;
  
  /// High elevation (dialogs, modals)
  static const double elevationHigh = 8.0;
  
  /// Extra high elevation (important elements)
  static const double elevationXHigh = 16.0;

  // ==================== ICON SIZES ====================
  
  /// Small icon - 16dp
  static const double iconS = 16.0;
  
  /// Medium icon - 24dp (default)
  static const double iconM = 24.0;
  
  /// Large icon - 32dp
  static const double iconL = 32.0;
  
  /// Extra large icon - 48dp
  static const double iconXL = 48.0;
  
  /// Extra extra large icon - 64dp
  static const double iconXXL = 64.0;
  
  /// Metric card icon size
  static const double metricIconSize = 48.0;
  
  /// List item icon size
  static const double listIconSize = 24.0;
  
  /// Button icon size
  static const double buttonIconSize = 20.0;

  // ==================== BUTTON SIZES ====================
  
  /// Button height
  static const double buttonHeight = 48.0;
  
  /// Small button height
  static const double buttonHeightSmall = 36.0;
  
  /// Large button height
  static const double buttonHeightLarge = 56.0;
  
  /// Icon button size
  static const double iconButtonSize = 40.0;

  // ==================== INPUT FIELD SIZES ====================
  
  /// Input field height
  static const double inputHeight = 56.0;
  
  /// Input field border width
  static const double inputBorderWidth = 1.0;
  
  /// Input field focused border width
  static const double inputBorderWidthFocused = 2.0;

  // ==================== CARD SIZES ====================
  
  /// Metric card height
  static const double metricCardHeight = 120.0;
  
  /// Metric card width (for grid)
  static const double metricCardWidth = 160.0;
  
  /// List item min height
  static const double listItemMinHeight = 80.0;
  
  /// List item max height
  static const double listItemMaxHeight = 150.0;

  // ==================== DIVIDER & BORDER ====================
  
  /// Divider thickness
  static const double dividerThickness = 1.0;
  
  /// Border width (default)
  static const double borderWidth = 1.0;
  
  /// Border width (emphasized)
  static const double borderWidthThick = 2.0;

  // ==================== APP BAR ====================
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// App bar elevation
  static const double appBarElevation = 0.0;

  // ==================== BOTTOM NAVIGATION ====================
  
  /// Bottom navigation bar height
  static const double bottomNavHeight = 60.0;
  
  /// Bottom navigation icon size
  static const double bottomNavIconSize = 24.0;

  // ==================== DIALOG ====================
  
  /// Dialog max width
  static const double dialogMaxWidth = 320.0;
  
  /// Dialog content padding
  static const double dialogPadding = 24.0;

  // ==================== LOADING INDICATOR ====================
  
  /// Loading spinner size
  static const double loadingSize = 40.0;
  
  /// Small loading spinner size
  static const double loadingSizeSmall = 24.0;

  // ==================== EMPTY STATE ====================
  
  /// Empty state icon size
  static const double emptyStateIconSize = 80.0;
  
  /// Empty state max width
  static const double emptyStateMaxWidth = 280.0;

  // ==================== GRID ====================
  
  /// Grid spacing
  static const double gridSpacing = 12.0;
  
  /// Grid cross axis count (for metric cards)
  static const int gridCrossAxisCount = 2;
  
  /// Grid child aspect ratio
  static const double gridChildAspectRatio = 1.3;

  // ==================== LIST ====================
  
  /// List item spacing
  static const double listItemSpacing = 8.0;
  
  /// List section spacing
  static const double listSectionSpacing = 16.0;

  // ==================== ANIMATION ====================
  
  /// Fast animation duration (milliseconds)
  static const int animationFast = 200;
  
  /// Medium animation duration (milliseconds)
  static const int animationMedium = 300;
  
  /// Slow animation duration (milliseconds)
  static const int animationSlow = 500;

  // ==================== CONSTRAINTS ====================
  
  /// Maximum content width (for tablets/large screens)
  static const double maxContentWidth = 600.0;
  
  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;
}